require 'active_support/core_ext/securerandom'

class TenantsController < ApplicationController
  def new
    @tenant = Tenant.new
    @user = User.new([])
  end

  def create
    @tenant = Tenant.new(tenant_params)

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
    params.require(:tenant).permit(:name, user: [:first_name, :last_name, :username, :email])
  end
end