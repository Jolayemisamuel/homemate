class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord

  def index
    @property = current_user.landlord.properties.find(params[:property_id])

    redirect_to property_path(@property)
  end

  def new
    @property = current_user.landlord.properties.find(params[:property_id])

    if @property.tenancies.active.present? || @property.tenancies.future.present?
      flash[:error] = 'Rooms cannot be created as active/future tenancy exists'
      redirect_back properties_path
    end

    @room = @property.rooms.new
  end

  def create
    @property = current_user.landlord.properties.find(params[:property_id])

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