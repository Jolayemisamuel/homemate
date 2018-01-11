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

class UtilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, except: [:index, :show]
  layout 'application'

  def index
    @utilities = Utility.includes(:utility_prices, :utility_usages)
  end

  def show
    @utility = Utility.includes(:utility_prices, :utility_usages).find(params[:id])
  end

  def edit
    @utility = Utility.find(params[:id])
  end

  def update
    @utility = Utility.find(params[:id])

    if @utility.update(utility_params)
      redirect_to property_path(@utility.property)
    else
      render 'edit'
    end
  end

  def new
    @property = Property.find(params[:property_id])
    @utility = @property.utilities.new
  end

  def create
    @property = Property.find(params[:property_id])
    @utility = @property.utilities.new(utility_params)

    if @utility.save
      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  def destroy
    @utility = Utility.find(params[:id])
    @property = @utility.property
    @utility.destroy

    redirect_to property_path(@property)
  end

  private

  def utility_params
    params.require(:utility).permit(:name, :provider_name, :included_in_rent, :prepay_charges)
  end
end