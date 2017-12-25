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

class Property < ApplicationRecord
  belongs_to :landlord
  has_many :rooms, dependent: :restrict_with_exception
  has_many :tenancies, as: :rentable, dependent: :restrict_with_exception
  has_many :tenants, through: :tenancies
  has_many :utilities, dependent: :destroy
  has_many :utility_usages, through: :utilities
  has_many :utility_charges, through: :utilities

  validates :name, presence: true
  validates :address, presence: true
  validates :postcode, presence: true
  validates :size, numericality: { greater_than: 0 }, allow_nil: true

  default_scope { where(active: true) }
end
