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

module Tenants
  class ContactsController < ApplicationController
    before_action :require_admin

    def edit
      tenant = Tenant.find(params[:tenant_id])
      @contact = tenant.contacts.find(params[:id])
    end

    def update
      tenant = Tenant.find(params[:tenant_id])
      @contact = tenant.contacts.find(params[:id])

      if @contact.update(contact_params)
        redirect_to tenant_path(tenant)
      else
        render 'contacts/edit', associable: tenant
      end
    end

    def new
      tenant = Tenant.find(params[:tenant_id])
      @contact = tenant.contacts.new

      render 'contacts/new', associable: tenant
    end

    def create
      tenant = Tenant.find(params[:tenant_id])
      @contact = tenant.contacts.new(contact_params)

      if @contact.valid?
        @contact.save!

        redirect_to tenant_path(tenant)
      else
        render 'contacts/new', associable: tenant
      end
    end

    private

    def contact_params
      params.require(:contact).permit(:title, :first_name, :last_name, :role, :email, :phone, :address)
    end
  end
end