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

class InvoiceMailer < ApplicationMailer
  layout 'mailer'

  # Send invoice creation email
  #
  # @param [Tenant] tenant The tenant that the invoice is created for
  # @param [Invoice] invoice The invoice instance
  # @param [Hash] pdf The PDF version of the invoice
  #
  # @return void
  def invoice_created(tenant, invoice, pdf)
    @tenant = tenant
    @contact = @tenant.contacts.where(primary: true).first!
    @invoice = invoice
    attachments[pdf.filename] = pdf.content

    mail(
        to: %("#{@contact.name}" <#{@contact.email}>),
        subject: 'Invoice for Your Tenancy'
    )
  end

  # Send payment failure notification
  #
  # @param [Transaction] transaction The transaction concerned
  #
  # @return void
  def payment_failed(transaction)
    @transaction = transaction
    @tenant = transaction.tenant
    @contact = @tenant.contacts.where(primary: true).first!

    landlord = Landlord.first!
    landlord_contact = landlord.contacts.where(primary: true).first!

    mail(
        to: %("#{@contact.name}" <#{@contact.email}>),
        cc: %("#{landlord_contact.name}" <#{landlord_contact.email}>),
        subject: 'Direct Debit Payment Failed'
    )
  end
end