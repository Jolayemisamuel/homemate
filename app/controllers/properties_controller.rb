##
# Copyright (c) Andrew Ying 2017.
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

class PropertiesController < ApplicationController
  before_action :authenticate_user!, :require_landlord

  def index
    @properties = current_user.landlord.properties.all
  end

  def show
    @property = current_user.landlord.properties.include(:rooms).find(params[:id])
    @tenancies = Tenancy.belongs_to_property(@property).order(start_date: :asc)
  end

  def edit
    @property = current_properties.find(params[:id])
  end

  def update
    @property = current_properties.find(params[:id])

    if @property.update(property_params)
      redirect_back fallback_location: properties_path
    else
      render 'edit'
    end
  end

  def new
    @property = current_user.landlord.properties.new
  end

  def create
    @property = current_user.landlord.properties.new(property_params)

    if @property.save
      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  def destroy
    @property.destroy!

    redirect_back properties_path
  end

  private

  def property_params
    params.require(:property).permit(:name, :address, :postcode, :size)
  end
end