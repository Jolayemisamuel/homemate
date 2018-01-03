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

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= super && User.includes({user_association: :associable}).find(@current_user.id)
  end

  def current_properties
    if current_user.is_tenant? && (rentable = current_user.tenant.active_tenancy&.rentable)
      collect(rentable.is_a? Room ? rentable.property : rentable)
    elsif current_user.is_landlord?
      current_user.landlord.properties
    else
      collect(Property.none)
    end
  end

  def require_tenant
    unless current_user.is_tenant?
      flash[:danger] = 'You are not authorised to visit this page'
      redirect_back fallback_location: root_path
    end
  end

  def require_landlord
    unless current_user.is_landlord?
      flash[:danger] = 'You are not authorised to visit this page'
      redirect_back fallback_location: root_path
    end
  end

  def can_edit_associable
    unless current_user.can_edit_associable?
      flash[:danger] = 'You are not authorised to visit this page'
      redirect_back fallback_location: root_path
    end
  end
end
