require 'active_support/core_ext/date'

class Tenancy < ApplicationRecord
  belongs_to :rentable, polymorphic: true
  belongs_to :tenant
  has_many :documents, as: :attachable
  has_many :transactions, as: :transactionable
  has_one :deposit

  validates :rent, numericality: true
  validates :start_date, presence: true

  def active
    today = Date.current
    where("start_date <= ? AND (end_date >= ? OR end_date IS NULL)", today, today)
  end

  def future
    where("start_date > ?", Date.current.end_of_day).order(start_date: :asc)
  end

  def is_active?
    (start_date.past? || start_date.today?) && (end_date.empty? || end_date.future?)
  end

  def is_future?
    start_date.future?
  end
end
