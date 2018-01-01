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

class TenanciesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_landlord, except: [:show]

  def index
    @rentable = find_rentable(params)
    @tenancies = @rentable.tenancies
  end

  def show
    if current_user.is_landlord?
      @tenancy = Tenancy.include(:rentable).find(params[:id])
    elsif current_user.is_tenant?
      @tenancy = current_user.tenant.tenancies.include(:rentable).find(params[:id])
    else
      abort
    end
  end

  def new
    if Tenant.all.empty?
      flash[:danger] = 'A tenant must exist before a tenancy can be created.'
      redirect_back fallback_location: root_path
    end

    @rentable = find_rentable(params)
    @tenancy = @rentable.tenancies.new
  end

  def create
    @rentable = find_rentable(params)
    @tenancy = @rentable.tenancies.new(tenancy_params)

    if @tenancy.valid?
      @tenancy.save

      redirect_to tenancy_path(@tenancy)
    else
      render 'new'
    end
  end

  def destroy
    @tenancy = Tenancy.find(params[:id])
    @tenancy.destroy

    redirect_back tenancies_path
  end

  private

  def find_rentable(params)
    if params.has_key? :property_id
      Property.find(params[:property_id])
    elsif params.has_key? :room_id
      Room.find(params[:room_id])
    else
      flash[:danger] = 'A rentable unit must be selected.'
      redirect_back fallback_location: root_path
    end
  end

  def tenancy_params
    params.require(:tenancy).permit(:tenant_id, :rent, :rent_period, :rent_payment_day, :start_date, :end_date)
  end
end