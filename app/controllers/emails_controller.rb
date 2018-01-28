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

class EmailsController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = current_user.contact.mailbox.inbox.page(params[:page]).per(15)
    render 'index', locals: { tab: 'inbox' }
  end

  def sent
    @messages = current_user.contact.mailbox.sentbox.page(params[:page]).per(15)
    render 'index', locals: { tab: 'sent' }
  end

  def trash
    @messages = current_user.contact.mailbox.trash.page(params[:page]).per(15)
    render 'index', locals: { tab: 'trash' }
  end

  def show
    @conversation = current_user.contact.mailbox.conversations.find_by_id(params[:id])
    receipts = current_user.contact.mailbox.receipts_for(@conversation)
    receipts.mark_as_read
    @email = Email.new(contact: current_user.contact)
  end

  def new
    @email = Email.new
  end

  def create
    @email = Email.new(email_params.except(:contact_id))

    if current_user.is_landlord?
      results = Contact.where.not(email: nil).all
    elsif current_user.is_tenant?
      landlord = Landlord.first
      results  = landlord.contacts.where.not(email: nil)
    else
      render status: 403
    end
    @email.contact = results.where(id: email_params[:contact_id])

    if @email.valid?
      current_user.contact.send_message(@email.contact, @email.message, @email.subject, sanitize_text: false)
      redirect_to emails_path
    else
      render 'new'
    end
  end

  private

  def email_params
    params.require(:email).permit(:subject, :message, :contact_id => [])
  end
end