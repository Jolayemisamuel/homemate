require 'active_support/core_ext/date'

class Tenancy < ApplicationRecord
  belongs_to :rentable, polymorphic: true
  belongs_to :tenant
  has_many :documents, as: :attachable
  has_many :transactions, as: :transactionable
  has_one :deposit

  validates_associated :tenant
  validates :rent, numericality: { greater_than: 0 }
  validates :rent_period, inclusion: '%w[w m]'
  validate :validate_rent_payment_day
  validates :start_date, presence: true

  def self.active
    today = Date.current
    where('start_date <= ? AND (end_date >= ? OR end_date IS NULL)', today, today)
  end

  def self.future
    where('start_date > ?', Date.current.end_of_day).order(start_date: :asc)
  end

  def is_active?
    (start_date.past? || start_date.today?) && (end_date.empty? || end_date.future?)
  end

  def is_future?
    start_date.future?
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
