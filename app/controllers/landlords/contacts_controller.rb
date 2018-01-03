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

module Landlords
  class ContactsController < ApplicationController
    before_action :authenticate_user!, :require_landlord, :can_edit_associable

    def edit
      landlord = Landlord.find(params[:landlord_id])
      @contact = landlord.contacts.find(params[:id])
    end

    def update
      landlord = Landlord.find(params[:landlord_id])
      @contact = landlord.contacts.find(params[:id])

      if @contact.update(contact_params)
        redirect_to landlord_path(landlord)
      else
        render 'contacts/edit', associable: landlord
      end
    end

    def new
      landlord = Landlord.find(params[:landlord_id])
      @contact = landlord.contacts.new

      render 'contacts/new', associable: landlord
    end

    def create
      landlord = Landlord.find(params[:landlord_id])
      @contact = landlord.contacts.new(contact_params)

      if @contact.valid?
        @contact.save!

        redirect_to landlord_path(landlord)
      else
        render 'contacts/new', associable: landlord
      end
    end

    private

    def contact_params
      params.require(:contact).permit(:title, :first_name, :last_name, :role, :email, :phone, :address)
    end
  end
end