class PropertiesController < ApplicationController
  before_action :require_landlord

  def index
    @properties = current_user.user_association.associable.properties.all
  end

  def show
    @property = Property.find(params[:id])
  end

  def new
    @property = current_user.user_association.associable.properties.new
  end

  def create
    @property = current_user.user_association.associable.properties.new(property_params)
    @property.active = true

    if @property.valid?
      @property.save

      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  def destroy
    @property = Property.find(params[:id])
    @property.destroy

    redirect_back properties_path
  end

  private

  def property_params
    params.require(:property).permit(:name, :address, :postcode, :size)
  end
end