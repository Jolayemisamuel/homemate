require 'active_support/core_ext/date'

class Invoice < ApplicationRecord
  belongs_to :tenant
  has_many :transactions
  has_many :documents, as: :attachable

  validates :balance, numericality: true

  def self.overdue
    where('due_date < ?', Date.current)
  end

  def self.due_soon(length = 3.days)
    where('due_date < ?', Date.current + length)
  end

  def self.is_overdue
    :due_date&.past?
  end
end
