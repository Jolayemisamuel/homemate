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
  class ChecksController < ApplicationController
    before_action :authenticate_user!
    before_action :require_landlord, except: [:new]
    before_action :have_encryption_key, only: [:new, :create]

    def index
      @tenant_checks = TenantCheck.all
    end

    def new
      @tenant = Tenant.find(params[:tenant_id])

      if current_user.is_tenant? && current_user.tenant == @tenant
        render 'info'
      elsif current_user.is_landlord?
        @tenant_check = @tenant.tenant_checks.new
        render 'new'
      else
        flash[:danger] = 'You are not authorised to visit this page'
        redirect_back fallback_location: root_path
      end
    end

    def create
      @tenant = Tenant.find(params[:tenant_id])
      @tenant_check = @tenant.tenant_checks.new(tenant_check_params.except(:document_to_attach))

      if @tenant_check.save
        document = @tenant_check.documents.new(
            name: tenant_check_params[:document_to_attach].original_filename,
            file: tenant_check_params[:document_to_attach],
            encrypted: true
        )
        document.document_accesses.new(
            owner: current_user.landlord
        )
        document.save!

        redirect_to tenant_path(@tenant)
      else
        render 'new'
      end
    end

    private

    def tenant_check_params
      params.require(:tenant_check).permit(:document_type, :document_to_attach, :expires)
    end
  end
end
