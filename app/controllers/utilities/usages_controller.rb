module Utilities
  class UsagesController < ApplicationController
    before_action :authenticate_user!

    def index
      @utility = Utility
        .where(property_id: current_properties.collect { |property| property.id })
        .includes(:utility_usages)
        .find(params[:utility_id])
      @usages = @utility.utility_usages
    end

    def new
      @utility = Utility
        .where(property_id: current_properties.collect { |property| property.id })
        .includes(:utility_usages)
        .find(params[:utility_id])
      @usage = @utility.utility_usages.new
    end

    def create
      @utility = Utility
        .where(property_id: current_properties.collect { |property| property.id })
        .includes(:utility_usages)
        .find(params[:utility_id])
      @usage = @utility.utility_usages.new(usage_params)
      @usage.projected = false

      if @usage.valid?
        @usage.save

        redirect_to property_path(@utility.property)
      else
        render 'new'
      end
    end

    private

    def usage_params
      params.require(:usage).permit(:date, :reading)
    end
  end
end