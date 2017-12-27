# Copyright (c) Andrew Ying 2017.
#
# This file is part of HomeMate.
#
# HomeMate is free software: you can redistribute it and/or modify
# it under the terms of version 3 of the GNU General Public License
# as published by the Free Software Foundation. You must preserve
# all reasonable legal notices and author attributions in this program
# and in the Appropriate Legal Notice displayed by works containing
# this program.
#
# HomeMate is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with HomeMate.  If not, see <http://www.gnu.org/licenses/>.

require 'active_support/core_ext/date'
require 'pdfkit'

class GenerateInvoiceJob < ApplicationJob
  def perform(tenancy, payment_date)
    tenant = tenancy.tenant
    invoice = tenant.invoices.new(
      issued: true,
      issued_on: Date.current,
      due_on: payment_date,
      paid: false
    )

    # Associate pending transactions
    tenant.transactions.where('invoice_id IS NULL AND processed = true AND failed = false').each do |t|
      t.invoice = invoice
    end

    # Add rent to invoice
    associate_rent_charges(invoice, tenancy, tenancy.rent_charges.order(to_date: desc).first.to_date.tomorrow,
                           payment_date.yesterday)

    # Check whether new utilities charges have been added since the last invoice
    last_invoice = tenant.invoices.order(issued_at: :desc).first
    associate_utility_charges(invoice, tenancy, last_invoice.empty? ? nil : last_invoice.issued_at)

    starting_balance = last_invoice.balance
    invoice.balance = starting_balance + invoice.transactions.sum('amount')
    invoice.save!

    pdf = PDFKit.new(
        render_to_string 'layouts/invoice', invoice: invoice, starting_balance: starting_balance
    )
    invoice.documents.create!(
      name: Date.current.strftime('Invoice-%d-%m-%Y.pdf'),
      file: pdf.to_pdf,
      encrypted: false
    )
  end

  # Create and associate rent charges to the invoice.
  #
  # @param [Invoice] invoice the invoice for the transactions to be associated to
  # @param [Tenancy] tenancy the tenancy for which rent charges need to be created
  # @param [Date] from the date from which rent need to be calculated
  # @param [Date] to the date to which rent to be calculated
  #
  # @return void
  def associate_rent_charges(invoice, tenancy, from, to)
    if tenancy.rent_payment_period == 'm'
      # If a full month of rent is due
      while to >= from.next_month.yesterday do
        rent_charge = tenancy.rent_charges.create!(
            from_date: from,
            to_date: from.next_month.yesterday,
            amount: tenancy.rent
        )
        invoice.transactions.build(
            credit_date: Date.current,
            description: 'Rent from ' + from.to_s(:rfc822) + 'to' + from.next_month.yesterday.to_s(:rfc822),
            amount: tenancy.rent,
            tenancy: tenancy,
            transactionable: rent_charge
        )

        from = from.next_month
      end

      # If a partial month remains
      if to > from
        amount = tenancy.rent * (to - from).days / 30

        rent_charge = tenancy.rent_charges.create!(
            from_date: from,
            to_date: to,
            amount: amount
        )
        invoice.transactions.build(
            credit_date: Date.current,
            description: 'Rent from ' + from.to_s(:rfc822) + ' to ' + to.to_s(:rfc822),
            amount: amount,
            tenancy: tenancy,
            transactionable: rent_charge
        )
      end
    else
      amount = tenancy.rent * (to - from + 1.day).days / 7

      rent_charge = tenancy.rent_charges.create!(
          from_date: from,
          to_date: to,
          amount: amount
      )
      invoice.transactions.build(
          credit_date: Date.current,
          description: 'Rent from ' + from.to_s(:rfc822) + 'to' + to.to_s(:rfc822),
          amount: amount,
          tenancy: tenancy,
          transactionable: rent_charge
      )
    end
  end

  # Associate utility charges billed from the `from` date
  #
  # @param [Invoice] invoice the invoice for the transactions to be associated to
  # @param [Tenancy] tenancy the tenancy concerned
  # @param [Date] from utility charges created after this date would be searched for:
  #   if nil utility charges created after the start of the tenancy would be searched
  #   for instead.
  def associate_utility_charges(invoice, tenancy, *from)
    tenancy.property.utilities.each do |utility|
      if @from.nil?
        # Look for charges for usages after the start of tenancy
        charges = utility.utility_charges.where('usage_to_date =< ? AND usage_from_date >= ?', Date.current,
                                                tenancy.start_date)
      else
        charges = utility.utility_charges.where('usage_to_date =< ? AND usage_to_date > ?', Date.current,
                                                from)
      end

      charges.each do |charge|
        invoice.transactions.build(
            credit_date: Date.current,
            description: utility.name + ' charges from ' + charge.usage_from_date.to_s(:rfc822) + ' to ' +
                charge.usage_to_date.to_s(:rfc822),
            amount: charge.amount,
            tenancy: tenancy,
            transactionable: charge
        )
      end
    end
  end
end