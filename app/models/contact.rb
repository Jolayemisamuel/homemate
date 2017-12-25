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

class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true
  has_one :user, required: false

  validates :title, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true
  validates :email, uniqueness: true, allow_nil: true
  validates_associated :contactable

  def has_user?
    User.where('contact_id', id).present?
  end
end
