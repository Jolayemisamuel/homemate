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

require 'active_support/core_ext/securerandom'

class TenantsController < ApplicationController
  before_action :authenticate_user!, :require_landlord
  before_action :have_encryption_key, only: [:new, :create]

  def index
    @tenants = Tenant.all
  end

  def show
    @tenant = Tenant.includes(:contacts, :tenant_checks, :tenancies).find(params[:id])
  end

  def edit
    @tenant = Tenant.find(params[:id])
  end

  def update
    @tenant = Tenant.find(params[:id])

    if @tenant.update(tenant_params)
      redirect_to tenant_path(@tenant)
    else
      render 'edit'
    end
  end

  def new
    @tenant = Tenant.new

    @contact = Contact.new
    @contact.contactable = @tenant

    @user = User.new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @tenant = Tenant.new(tenant_params.except(:user, :contact))
        @tenant.save!

        @contact = @tenant.contacts.new(tenant_params[:contact])
        @contact.primary = true
        @contact.role = "Tenant"

        @user = User.new(tenant_params[:user])
        @user.contact = @contact
        @user.email = tenant_params[:contact][:email]
        @password = SecureRandom::base58(12)
        @user.password = @password
        @user.password_confirmation = @password
        @user.save!

        association = @tenant.user_associations.new
        association.user = @user
        association.save!

        if tenant_params[:no_application] == '0'
          application = @tenant.tenant_applications.new
          application.save!
        end
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      flash[:danger] = 'Failed to create new tenant. This is normally because one of the attributes is invalid.'
      render 'new' && return
    end

    UserMailer.account_created(@user, @password).deliver_later
    redirect_to tenants_path
  end

  private

  def tenant_params
    params.require(:tenant).permit(
      :name, :no_application,
      user: [:username],
      contact: [:title, :first_name, :last_name, :phone, :address, :email]
    )
  end
end