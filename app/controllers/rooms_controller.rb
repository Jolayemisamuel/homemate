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

class RoomsController < ApplicationController
  before_action :authenticate_user!, :require_landlord

  def index
    @property = current_user.landlord.properties.find(params[:property_id])

    redirect_to property_path(@property)
  end

  def edit
    @room = Room.where('property_id', current_properties.collect { |p| p.id }).find(params[:id])
  end

  def update
    @room = Room.where('property_id', current_properties.collect { |p| p.id }).find(params[:id])

    if @room.update(room_params)
      redirect_to property_path(@room.property)
    else
      render 'edit'
    end
  end

  def new
    @property = current_user.landlord.properties.find(params[:property_id])

    if @property.tenancies.active.present? || @property.tenancies.future.present?
      flash[:danger] = 'Rooms cannot be created as active/future tenancy exists'
      redirect_back properties_path
    end

    @room = @property.rooms.new
  end

  def create
    @property = current_user.landlord.properties.find(params[:property_id])

    if @property.tenancies.active.present? || @property.tenancies.future.present?
      flash[:danger] = 'Rooms cannot be created as active/future tenancy exists'
      redirect_back properties_path
    end

    @room = @property.rooms.new(room_params)
    @room.active = true

    if @room.save
      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  def destroy
    @room = current_user.landlord.rooms.find(params[:id])
    @property = @room.property
    @room.destroy

    redirect_to property_path(@property)
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end