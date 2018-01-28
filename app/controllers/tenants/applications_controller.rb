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

module Tenants
  class ApplicationsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_landlord, only: [:create, :edit, :update, :complete]

    def show
      @current_user = current_user

      if current_user.is_tenant?
        tenant = current_user.user_association.associable
        @application = tenant.tenant_applications.find(params[:id])
      else
        @application = TenantApplication.includes(:tenant).find(params[:id])
      end
    end

    def create
      tenant = Tenant.includes(:tenant_applications).find(application_params[:tenant_id])

      if tenant.current_application.present?
        flash[:danger] = 'A current application is already present. No new tenancy application can be created until the'
          + 'current application has been processed.'
      else
        tenant.tenant_applications.create!
      end

      redirect_to tenant_path(tenant)
    end

    def edit
      @tenant_application = TenantApplication.includes(:tenant).find(params[:id])
    end

    def update
      @tenant_application = TenantApplication.includes(:tenant).find(params[:id])

      if @tenant_application.update(edit_application_params)
        redirect_to tenant_path(@tenant_application.tenant)
      else
        render 'edit'
      end
    end

    def complete
      @tenant_application = TenantApplication.find(params[:id])
      @tenant_application.update(complete: true)

      redirect_to new_email_path
    end

    private

    def application_params
      params.require(:tenant_application).permit([:tenant_id])
    end

    def edit_application_params
      params.require(:tenant_application).permit([:reference_received, :reference_passed])
    end
  end
end