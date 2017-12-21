class TenanciesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, except: [:show]

  def index
    @rentable = find_rentable(params)
    @tenancies = @rentable.tenancies
  end

  def show
    if current_user.is_landlord?
      @tenancy = current_user.landlord.tenancies.include(:rentable).find(params[:id])
    elsif current_user.is_tenant?
      @tenancy = current_user.tenant.tenancies.include(:rentable).find(params[:id])
    else
      abort
    end
  end

  def new
    if Tenant.count == 0
      flash[:danger] = 'A tenant must exist before a tenancy can be created.'
      redirect_back fallback_location: root_path
    end

    @rentable = find_rentable(params)
    @tenancy = @rentable.tenancies.new
  end

  def create
    @rentable = find_rentable(params)
    @tenancy = @rentable.tenancies.new(tenancy_params)

    if @tenancy.valid?
      @tenancy.save

      redirect_to tenancy_path(@tenancy)
    else
      render 'new'
    end
  end

  def destroy
    @tenancy = current_user.landlord.tenancies.find(params[:id])
    @tenancy.destroy

    redirect_back tenancies_path
  end

  private

  def find_rentable(params)
    if params.has_key? :property_id
      current_user.landlord.properties.find(params[:property_id])
    elsif params.has_key? :room_id
      current_user.landlord.rooms.find(params[:room_id])
    else
      flash[:danger] = 'A rentable unit must be selected.'
      redirect_back fallback_location: root_path
    end
  end

  def tenancy_params
    params.require(:tenancy).permit(:tenant, :rent, :rent_period, :rent_payment_day, :start_date, :end_date)
  end
end