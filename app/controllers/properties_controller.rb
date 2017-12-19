class PropertiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, except: [:show]

  def index
    @properties = current_user.landlord.properties.all
  end

  def show
    if current_user.is_landlord?
      @property = current_user.landlord.properties.find(params[:id])
    elsif current_user.is_tenant?
      @property = current_user.tenant.active_tenancy.property

      redirect_to property_path(@property) if @property.id != params[:id]
    else
      abort
    end
  end

  def new
    @property = current_user.landlord.properties.new
  end

  def create
    @property = current_user.landlord.properties.new(property_params)

    if @property.valid?
      @property.save

      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  def destroy
    @property.destroy

    redirect_back properties_path
  end

  private

  def property_params
    params.require(:property).permit(:name, :address, :postcode, :size)
  end
end