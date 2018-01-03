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
  class UsersController < ApplicationController
    include UserCrud
    before_action :authenticate_user!, :require_landlord

    def edit
      tenant = Tenant.find(params[:tenant_id])
      @user = tenant.users.find(params[:id])
    end

    def update
      tenant = Tenant.find(params[:tenant_id])
      @user = tenant.users.find(params[:id])

      begin
        ActiveRecord::Base.transaction do
          update_record(@user)
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        flash[:danger] = 'Failed to update user. This is normally because one of the attributes is invalid.'
        render 'users/edit', associable: tenant && return
      end

      redirect_to tenant_path(tenant)
    end

    def new
      tenant = Tenant.find(params[:tenant_id])
      @contact = Contact.new
      @contact.contactable = tenant

      @user = User.new

      render 'users/new', associable: tenant
    end

    def create
      tenant = Tenant.find(params[:tenant_id])

      begin
        ActiveRecord::Base.transaction do
          create_record(tenant)
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        flash[:danger] = 'Failed to create new user. This is normally because one of the attributes is invalid.'
        render 'users/new', associable: tenant && return
      end

      UserMailer.account_created(@user, @password).deliver_later
      redirect_to tenant_path(tenant)
    end

    def unlock
      @user = User.find(params[:id])
      @user.unlock_access!

      redirect_back fallback_location: root_path
    end

    private

    def user_params
      params.require(:user).permit(:username, contact: [:title, :first_name, :last_name, :phone, :address])
    end
  end
end