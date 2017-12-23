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

require 'active_support/core_ext/securerandom'

class TenantsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, except: [:show]

  def index
    @tenants = Tenant.all
  end

  def show
    if current_user.is_landlord?
      @tenant = Tenant.find(params[:id])
    elsif current_user.is_tenant?
      @tenant = current_user.tenant
      redirect_to tenant_path(@tenant) if @tenant.id != params[:id]
    else
      abort
    end
  end

  def new
    @tenant = Tenant.new
    @user = User.new
  end

  def create
    @tenant = Tenant.new(tenant_params.except(:user))
    @user = User.new(tenant_params[:user])

    @password = SecureRandom::base58(12)
    @user.password = @password
    @user.password_confirmation = @password

    if @tenant.valid? && @user.valid?
      @tenant.save

      @user.save

      association = UserAssociation.new
      association.user = @user
      association.associable = @tenant
      association.save

      redirect_to tenants_path
    else
      render 'new'
    end
  end

  private

  def tenant_params
    params.require(:tenant).permit(:name, user: [:username, :email])
  end
end