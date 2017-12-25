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

module ControllerConcerns
  class UserCrud
    extends ActiveSupport::Concern

    def create_record(associable, primary = false, random_password = true)
      @contact = associable.contacts.new(user_params[:contact])
      if primary
        @contact.role = associable.model_name.human
      end
      @contact.save!

      @user = User.new(user_params.except(:contact))
      @user.contact = @contact
      @user.email = @contact.email
      if random_password
        @password = SecureRandom::base58(12)
        @user.password = password
        @user.password_confirmation = @password
      end
      @user.save!

      association = associable.user_associations.new
      association.user = @user
      association.save!
    end

    def update_record(user, regenerate_password = true)
      contact = user.contact
      contact.update!(user_params[:contact])

      user.username = user_params[:username]
      if user.email != contact.email
        user.email = contact.email
      end
      if regenerate_password
        @password = SecureRandom::base58(12)
        @user.password = password
        @user.password_confirmation = @password
      end
      user.update!
    end

    private

    def user_params
      params.require(:user).permit(:username, contact: [:title, :first_name, :last_name, :phone, :address])
    end
  end
end