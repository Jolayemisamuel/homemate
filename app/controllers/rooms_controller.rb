class RoomsController < ApplicationController
  before_action :require_landlord

  def new
    @property = Property.find(params[:property_id])

    if @property.tenancies.active.present? || @property.tenancies.future.present?
      flash[:error] = 'Rooms cannot be created as active/future tenancy exists'
      redirect_back properties_path
    end

    @room = @property.rooms.new
  end

  def create
    @property = Property.find(params[:property_id])

    if @property.tenancies.active.present? || @property.tenancies.future.present?
      flash[:error] = 'Rooms cannot be created as active/future tenancy exists'
      redirect_back properties_path
    end

    @room = @property.rooms.new(room_params)
    @room.active = true

    if @room.valid?
      @room.save

      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end