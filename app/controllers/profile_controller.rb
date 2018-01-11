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

class ProfileController < ApplicationController
  include UserCrud
  before_action :authenticate_user!

  def edit
    @current_user = current_user
  end

  def update
    @current_user = current_user

    begin
      ActiveRecord::Base.transaction do
        update_record(@current_user) do |user|
          if user.is_tenant? && user.tenant.current_application.present?
            application = user.tenant.current_application
            application.contact_completed = profile_completed(user)
            application.save!
          end

          if user_params[:current_password].present?
            user.current_password = user_params[:current_password]
            user.password = user_params[:password]
            user.password_confirmation = user_params[:password_confirmation]
            bypass_sign_in(user)
          end
        end
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      flash[:danger] = 'Failed to update your profile. This is normally because one of the attributes is invalid.'
      render 'edit'
    end

    redirect_to root_path
  end

  def profile_completed(user)
    !(user.contact.phone.empty? || user.contact.address.empty?)
  end

  private

  def user_params
    params.require(:user).permit(
      :username, :current_password, :password, :password_confirmation,
      contact: [:title, :first_name, :last_name, :email, :phone, :address]
    )
  end
end