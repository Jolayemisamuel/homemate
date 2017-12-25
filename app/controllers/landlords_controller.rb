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

  def index
    @landlords = Landlord.all
  end

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

  def new
    @landlord = Landlord.new

    @contact = Contact.new
    @contact.contactable = @landlord

    @user = User.new
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @landlord = Landlord.new(landlord_params.except(:user, :contact))
        @landlord.save!

        @contact = @landlord.contacts.new(landlord_params[:contact])
        @contact.primary = true
        @contact.role = "Landlord"

        @user = User.new(landlord_params[:user])
        @user.contact = @contact
        @user.email = @contact.email
        @password = SecureRandom::base58(12)
        @user.password = @password
        @user.password_confirmation = @password
        @user.save!

        association = @landlord.user_associations.new
        association.user = @user
        association.save!
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      flash[:danger] = 'Failed to create new landlord. This is normally because one of the attributes is invalid.'
      render 'new' && return
    end

    redirect_to landlords_path
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