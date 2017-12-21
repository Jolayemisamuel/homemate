class UtilityPricesController < ApplicationController
  before_action :authenticate_user!, :require_landlord

  def new
    @utility = current_user.landlord.utilities.find(params[:utility_id])
    @utility_price = @utility.utility_prices.new
  end

  def create
    @utility = current_user.landlord.utilities.find(params[:utility_id])
    @utility_price = @utility.utility_prices.new(price_params)

    if @utility_price.valid?
      @utility_price.save

      redirect property_path(@utility.property)
    else
      render 'new'
    end
  end

  private

  def price_params
    params.require(:utility_price).permit(:name, :price, :usage_based, :usage_unit, :length_unit)
  end
end