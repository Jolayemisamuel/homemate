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

module Landlords
  class UsersController < ApplicationController
    include UserCrud
    before_action :authenticate_user!, :require_landlord, :can_edit_associable

    def edit
      landlord = Landlord.find(params[:landlord_id])
      @user = landlord.users.find(params[:id])
    end

    def update
      landlord = Landlord.find(params[:landlord_id])
      @user = landlord.users.find(params[:id])

      begin
        ActiveRecord::Base.transaction do
          update_record(@user)
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        flash[:danger] = 'Failed to update user. This is normally because one of the attributes is invalid.'
        render 'users/edit', associable: landlord
        return
      end

      redirect_to landlord_path(landlord)
    end

    def new
      landlord = Landlord.find(params[:landlord_id])
      @contact = landlord.contacts.new
      @user = User.new

      render 'users/new', associable: landlord
    end

    def create
      landlord = Landlord.find(params[:landlord_id])

      begin
        ActiveRecord::Base.transaction do
          create_record(landlord)
        end
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
        flash[:danger] = 'Failed to create new user. This is normally because one of the attributes is invalid.'
        render 'users/new', associable: landlord
        return
      end

      UserMailer.account_created(@user, @password).deliver_later
      redirect_to landlord_path(landlord)
    end

    def unlock
      @user = User.find(params[:id])
      @user.unlock_access!

      redirect_back fallback_location: root_path
    end
  end
end