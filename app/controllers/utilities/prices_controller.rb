module Utilities
  class PricesController < ApplicationController
    before_action :authenticate_user!, :require_landlord

    def edit
      @utility = Utility.find(params[:utility_id])
      @utility_price = @utility.utility_prices.find(params[:id])
    end

    def update
      @utility = Utility.find(params[:utility_id])
      @utility_price = @utility.utility_prices.find(params[:id])

      if @utility_price.update(price_params)
        redirect_to utility_path(@utility)
      else
        render 'edit'
      end
    end

    def new
      @utility = Utility.find(params[:utility_id])
      @utility_price = @utility.utility_prices.new
    end

    def create
      @utility = Utility.find(params[:utility_id])
      @utility_price = @utility.utility_prices.new(price_params)

      if @utility_price.save
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
end