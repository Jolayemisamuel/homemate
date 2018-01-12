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

class Landlord < ApplicationRecord
  include CanOwnDocuments

  has_many :user_associations, as: :associable, dependent: :restrict_with_exception
  has_many :users, through: :user_associations
  has_many :contacts, as: :contactable, dependent: :destroy

  has_many :properties, dependent: :restrict_with_exception
  has_many :rooms, through: :properties
  has_many :utilities, through: :properties

  validates :name, presence: true
end
