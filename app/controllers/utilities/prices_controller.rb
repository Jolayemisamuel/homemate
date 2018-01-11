##
# Copyright (c) Andrew Ying 2017-18.
#
# This file is part of HomeMate.
#
# HomeMate is free software: you can redistribute it and/or modify
# it under the terms of version 3 of the GNU General Public License
# as published by the Free Software Foundation. You must preserve
# all reasonable legal notices and author attributions in this program
# and in the Appropriate Legal Notice displayed by works containing
# this program.
#
# HomeMate is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with HomeMate.  If not, see <http://www.gnu.org/licenses/>.
##

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
        redirect_to property_path(@utility.property)
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