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

require 'active_support/core_ext/date'

class Tenancy < ApplicationRecord
  belongs_to :rentable, polymorphic: true
  belongs_to :tenant
  has_many :documents, as: :attachable
  has_many :transactions
  has_one :deposit

  validates_associated :tenant
  validates :rent, numericality: { greater_than: 0 }
  validates :rent_period, inclusion: {in: %w[w m], message:"%{value} is not a valid rent period"}
  validate :validate_rent_payment_day
  validates :start_date, presence: true

  def self.active
    today = Date.current
    where('start_date <= ? AND (end_date >= ? OR end_date IS NULL)', today, today)
  end

  def self.future
    where('start_date > ?', Date.current.end_of_day).order(start_date: :asc)
  end

  def self.belongs_to_property(property)
    where(rentable_type: 'Property').where(rentable_id: property.id)
      .or(where(rentable_type: 'Room').where(rentable_id: property.rooms.each.pluck(&:id)))
  end

  def is_active?
    (start_date.past? || start_date.today?) && (end_date.empty? || end_date.future?)
  end

  def is_future?
    start_date.future?
  end

  def belongs_to_property?
    rentable.is_a? Property
  end

  def belongs_to_room?
    rentable.is_a? Room
  end

  def property
    (rentable.is_a? Room) ? rentable.property : rentable
  end

  private

  def validate_rent_payment_day
    if rent_period == 'w' && !rent_payment_day.in?(1..7)
      errors.add(:rent_payment_day, 'is not a valid rent payment day')
    elsif rent_period == 'm' && !rent_payment_day.in?(1..28)
      errors.add(:rent_payment_day, 'is not a valid rent payment day')
    end
  end
end
