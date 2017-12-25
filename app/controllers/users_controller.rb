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

class UsersController < ApplicationController
  include ControllerConcerns::UserCrud
  before_action :authenticate_user!, :require_tenant_or_landlord

  def new
    @contact = current_user.user_association.associable.contact.new
    @user = User.new
    @user.contact = @contact

    render 'new', associable: nil
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        create_record(current_user.user_association.associable)
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      flash[:danger] = 'Failed to create new user. This is normally because one of the attributes is invalid.'
      render 'new', associable: nil && return
    end

    redirect_to contacts_path
  end

  def edit
    @user = current_user.user_association.associable.users.find(params[:id])
    @contact = @user.contact

    render 'edit', associable: nil
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        update_record(@user)
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      flash[:danger] = 'Failed to update user. This is normally because one of the attributes is invalid.'
      render 'edit', associable: nil && return
    end
  end
end