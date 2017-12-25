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

class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :lockable

  belongs_to    :contact
  has_one :user_association
  has_one :landlord, through: :user_association, source: :associable, source_type: 'Landlord'
  has_one :tenant, through: :user_association, source: :associable, source_type: 'Tenant'

  validates_associated :contact
  validates :username, uniqueness: true, if: :username_changed?
  validates :email, uniqueness: true, if: :email_changed?
  validates :password, confirmation: true, allow_nil: true

  def is_tenant?
    user_association.associable.is_a? Tenant
  end

  def is_landlord?
    user_association.associable.is_a? Landlord
  end
end
