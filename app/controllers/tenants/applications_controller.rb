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

    def show
      if current_user.is_tenant?
        @tenant = current_user.user_association.associable.includes(:tenant_applications).find(params[:tenant_id])
      else
        @tenant = Tenant.includes(:tenant_applications).find(params[:tenant_id])
      end

      @application = @tenant.tenant_applications.find(params[:id])
    end

    def new
    end

    def create
    end
  end
end