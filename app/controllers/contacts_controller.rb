##
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
##

class ContactsController < ApplicationController
  before_action :authenticate_user!, :require_tenant_or_landlord

  def index
    @contacts = current_user.user_association.associable.contacts
  end

  def new
    @contact = current_user.user_association.associable.contacts.new
  end

  def create
    @contact = current_user.user_association.associable.contacts.new(contact_params)

    if @contact.save
      redirect_to contacts_path
    else
      render 'new'
    end
  end

  def edit
    @contact = current_user.user_association.associable.contacts.find(params[:id])
  end

  def update
    @contact = current_user.user_association.associable.contacts.find(params[:id])

    if @contact.update(contact_params)
      redirect_to contacts_path
    else
      render 'edit'
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:title, :first_name, :last_name, :role, :email, :phone, :address)
  end
end