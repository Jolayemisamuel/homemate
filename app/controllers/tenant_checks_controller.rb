class TenantChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, except: [:new]

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
    @tenant_check = @tenant.tenant_checks.new(tenant_check_params)

    if @tenant_check.valid?
      @tenant_check.save
      @tenant_check.documents.new(
          name: params[:document_to_attach].original_filename,
          file: params[:document_to_attach],
          encrypted: true
      )

      redirect_to tenant_path(@tenant)
    else
      render 'new'
    end
  end

  private

  def tenant_check_params
    params.require(:tenant_check).permit(:document_type, :expires)
  end
end