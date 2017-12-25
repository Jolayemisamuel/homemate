class UtilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, except: [:index, :show]
  layout 'application'

  def index
    @utilities = Utility.where(
        property_id: current_properties.collect { |property| property.id }
    ).include(:utility_prices, :utility_usages)
  end

  def show
    @utility = Utility.where(
        property_id: current_properties.collect { |property| property.id }
    ).include(:utility_prices, :utility_usages).find(params[:id])
  end

  def edit
    @utility = current_user.landlord.utilities.find(params[:id])
  end

  def update
    @utility = current_user.landlord.utilities.find(params[:id])

    if @utility.update(utility_params)
      redirect_to property_path(@utility.property)
    else
      render 'edit'
    end
  end

  def new
    @property = current_user.landlord.properties.find(params[:property_id])
    @utility = @property.utilities.new
  end

  def create
    @property = current_user.landlord.properties.find(params[:property_id])
    @utility = @property.utilities.new(utility_params)

    if @utility.save
      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  def destroy
    @utility = current_user.landlord.utilities.find(params[:id])
    @property = @utility.property
    @utility.destroy

    redirect_to property_path(@property)
  end

  private

  def utility_params
    params.require(:utility).permit(:name, :provider_name, :included_in_rent, :prepay_charges)
  end
end