##
# Copyright (c) Andrew Ying 2017-18.
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
##

require 'active_support/core_ext/date'
require 'pdfkit'

class GenerateInvoiceJob < ApplicationJob
  # Generate an invoice for the fee derived from a tenancy
  #
  # @param [Tenancy] tenancy The tenancy instance
  # @param [Date] payment_date The payment date
  #
  # @return void
  def perform(tenancy, payment_date)
    @tenancy = tenancy
    tenant = @tenancy.tenant
    @invoice = tenant.invoices.new(
      issued: true,
      issued_on: Date.current,
      due_on: payment_date,
      paid: false
    )

    # Associate pending transactions
    tenant.transactions.where('invoice_id IS NULL AND processed = true AND failed = false').each do |t|
      t.invoice = @invoice
    end

    # Add rent to invoice
    associate_rent_charges({
      from: @tenancy.rent_charges.order(to_date: desc).first.to_date.tomorrow,
      to: payment_date.yesterday
    })

    # Check whether new utilities charges have been added since the last invoice
    last_invoice = tenant.invoices.order(issued_at: :desc).first
    associate_utility_charges(last_invoice.empty? ? nil : last_invoice.issued_at)

    starting_balance = last_invoice.balance
    @invoice.balance = starting_balance + @invoice.transactions.sum('amount')
    @invoice.save!

    file = generate_pdf_invoice(starting_balance)
    InvoiceMailer.invoice_created(tenant, @invoice, {
        filename: Date.current.strftime('Invoice-%d-%m-%Y.pdf'),
        content: file
    }).deliver_later
  end

  private

  # Create and associate rent charges to the invoice.
  #
  # @param [Hash] params the parameters of the charges to be created
  #
  # @return void
  def associate_rent_charges(params)
    from = params.from
    to = params.to

    if @tenancy.rent_payment_period == 'm'
      # Calculate the end date assuming a full month of rent period
      current_to = from.next_month.yesterday

      # If a full month of rent is due
      while to >= current_to do
        associate_rent_charge({
          from: from,
          to: current_to,
          amount: @tenancy.rent
        })

        from = from.next_month
        current_to = from.next_month.yesterday
      end

      # If a partial month remains
      associate_rent_charge({
        from: from,
        to: to,
        amount: @tenancy.rent * (to - from).days / 30
      }) if to > from
    else
      associate_rent_charge({
        from: from,
        to: to,
        amount: @tenancy.rent * (to - from).days / 7
      })
    end
  end

  # Create and associate a single rent charge to the invoice.
  #
  # @param [Hash] params the parameters of the rent charge
  #
  # @return void
  def associate_rent_charge(params)
    rent_charge = @tenancy.rent_charges.create!(
        from_date: params.from,
        to_date: params.to,
        amount: params.amount
    )
    @invoice.transactions.build(
        credit_date: Date.current,
        description: 'Rent from ' + params.from.to_s(:rfc822) + 'to' + params.to.to_s(:rfc822),
        amount: params.amount,
        tenancy: @tenancy,
        transactionable: rent_charge
    )
  end

  # Associate utility charges billed from the `from` date
  #
  # @param [Date] from utility charges created after this date would be searched for:
  #   if nil utility charges created after the start of the tenancy would be searched
  #   for instead.
  def associate_utility_charges(*from)
    @tenancy.property.utilities.each do |utility|
      if @from.nil?
        # Look for charges for usages after the start of tenancy
        charges = utility.utility_charges.where('usage_to_date =< ? AND usage_from_date >= ?', Date.current,
                                                @tenancy.start_date)
      else
        charges = utility.utility_charges.where('usage_to_date =< ? AND usage_to_date > ?', Date.current,
                                                from)
      end

      charges.each do |charge|
        @invoice.transactions.build(
            credit_date: Date.current,
            description: utility.name + ' charges from ' + charge.usage_from_date.to_s(:rfc822) + ' to ' +
                charge.usage_to_date.to_s(:rfc822),
            amount: charge.amount,
            tenancy: @tenancy,
            transactionable: charge
        )
      end
    end
  end

  # Generate PDF version of the invoice
  #
  # @param [Integer|Float] starting_balance The balance carried forward
  #
  # @return String
  def generate_pdf_invoice(starting_balance)
    pdf = PDFKit.new(
        render_to_string 'layouts/invoice', invoice: @invoice, starting_balance: starting_balance
    )
    @invoice.documents.create!(
        name: Date.current.strftime('Invoice-%d-%m-%Y.pdf'),
        file: pdf.to_pdf,
        encrypted: false
    )

    pdf.to_pdf
  end
end