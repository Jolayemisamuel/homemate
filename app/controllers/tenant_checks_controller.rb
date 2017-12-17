class TenantChecksController < ApplicationController
  def index
    @tenant_checks = TenantCheck.all
  end

  def new
    @tenant = Tenant.find(params[:tenant_id])

    if current_user.is_tenant? && current_user.user_association.associable == @tenant
      render 'info'
    elsif current_user.is_landlord?
      render 'new'
    else
      flash[:error] = 'You are not authorised to visit this page'
      redirect_back root_path
    end
  end

  def create
    unless current_user.is_landlord?
      flash[:error] = 'You are not authorised to visit this page'
      redirect_back root_path
    end

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