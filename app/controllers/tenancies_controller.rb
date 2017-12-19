class TenanciesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, only: [:index, :new, :create, :destroy]

  def index
    if params.has_key? :property_id
      @rentable = current_user.landlord.properties.find(params[:property_id])
    elsif params.has_key? :room_id
      @rentable = current_user.landlord.rooms.find(params[:room_id])
    else
      flash[:error] = 'A rentable unit must be selected.'
      redirect_back root_path
    end

    @tenancies = @rentable.tenancies
  end

  def show
    @tenancy = Tenancy.find(params[:id])
  end

  def new
    if params.has_key? :property_id
      @rentable = current_user.landlord.properties.find(params[:property_id])
    elsif params.has_key? :room_id
      @rentable = current_user.landlord.rooms.find(params[:room_id])
    else
      flash[:error] = 'A rentable unit must be selected.'
      redirect_back root_path
    end

    unless Tenant.present?
      flash[:error] = 'A tenant must exist before a tenancy can be created.'
      redirect_back root_path
    end

    @tenancy = @rentable.tenancies.new
  end

  def create
    if params.has_key? :property_id
      @rentable = current_user.landlord.properties.find(params[:property_id])
    elsif params.has_key? :room_id
      @rentable = current_user.landlord.rooms.find(params[:room_id])
    else
      flash[:error] = 'A rentable unit must be selected.'
      redirect_back root_path
    end

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

  def tenancy_params
    params.require(:tenancy).permit(:tenant, :rent, :rent_period, :rent_payment_day, :start_date, :end_date)
  end
end