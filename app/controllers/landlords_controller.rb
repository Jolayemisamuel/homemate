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

require 'active_support/core_ext/securerandom'

class LandlordsController < ApplicationController
  before_action :require_admin

  def edit
    @landlord = Landlord.find(params[:id])
  end

  def update
    @landlord = Landlord.find(params[:id])

    if @landlord.update(landlord_params)
      redirect_to landlord_path(@landlord)
    else
      render 'update'
    end
  end

  private

  def landlord_params
    params.require(:landlord).permit(
        :name,
        user: [:username],
        contact: [:title, :first_name, :last_name, :phone, :address]
    )
  end
end