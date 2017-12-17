class UtilitiesController < ApplicationController
  before_action :require_landlord, except: [:index]
  layout 'application'

  def show
    @property = Property.find(params[:property_id])
    @utilities = @property.utilities
  end

  def new
    @property = Property.find(params[:property_id])
    @utility = @property.utilities.new
  end

  def create
    @property = Property.find(params[:property_id])
    @utility = @property.utilities.new(utility_params)

    if @utility.valid?
      @utility.save

      redirect_to property_path(@property)
    else
      render 'new'
    end
  end

  private

  def utility_params
    params.require(:utility).permit(:name)
  end
end