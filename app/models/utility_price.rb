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

class UtilityPrice < ApplicationRecord
  belongs_to :utility

  validates :name, presence: true
  validates_associated :utility
  validates :price, numericality: { greater_than: 0 }
  validate :validate_usage_unit, if: :usage_based
  validate :validate_length_unit, unless: :usage_based

  def readable_price
    Settings.payment.currency + sprintf('%0.02f', price) + '/' + unit
  end

  def unit
    usage_based ? usage_unit : length_unit
  end

  private

  def validate_usage_unit
    errors.add(:usage_unit, 'must not be empty') if usage_unit.empty?
    errors.add(:length_unit, 'must be empty') if length_unit.present?
  end

  def validate_length_unit
    errors.add(:length_unit, 'is not a valid unit') unless length_unit.in?(%w[d w m])
    errors.add(:usage_unit, 'must be empty') if usage_unit.present?
  end
end
