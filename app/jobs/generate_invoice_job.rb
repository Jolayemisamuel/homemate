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

class GenerateInvoiceJob < ApplicationJob
  def perform(tenancy, payment_date, monthly)
    tenant = tenancy.tenant
    invoice = tenant.invoices.new

    pending_transactions = tenant.transactions.where('invoice_id IS NULL AND processed = true AND failed = false')

    pending_transactions.each do |t|
      t.invoice = invoice
    end

    # Add rent to invoice
    from = tenancy.rent_charges.order(to_date: desc).first.to_date.tomorrow
    to = payment_date.yesterday

    if monthly
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

    # Check whether new utilities charges have been added since the last invoice
    last_invoice = tenant.invoices.order(issued_at: :desc).first

    tenancy.property.utilities.each do |utility|
      if last_invoice.empty
        # Look for charges for usages after the start of tenancy
        charges = utility.utility_charges.where('usage_to_date =< ? AND usage_from_date >= ?', Date.current,
          tenancy.start_date)
      else
        charges = utility.utility_charges.where('usage_to_date =< ? AND usage_to_date > ?', Date.current,
          last_invoice.issued_at)
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

    starting_balance = last_invoice.balance
    invoice.balance = starting_balance + invoice.transactions.sum('amount')
    invoice.issued = true
    invoice.issued_on = Date.current
    invoice.due_on = payment_date
    invoice.paid = false
    invoice.save!

    pdf = PDFKit.new(render_to_string 'layouts/invoice', invoice, starting_balance)
    invoice.documents.create!(
      name: Date.current.strftime('Invoice%d-%m-%Y.pdf'),
      file: pdf.to_pdf,
      encrypted: false
    )
  end
end