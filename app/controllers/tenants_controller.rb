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