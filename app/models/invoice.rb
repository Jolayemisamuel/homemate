require 'active_support/core_ext/date'

class Invoice < ApplicationRecord
  belongs_to :tenant
  has_many :transactions
  has_many :documents, as: :attachable

  validates :balance, numericality: true

  def self.overdue
    where('issued = TRUE AND due_date IS NOT NULL AND due_date < ?', Date.current)
  end

  def self.due_soon(length = 3.days)
    today = Date.current
    where('issued = TRUE AND due_date IS NOT NULL AND due_date >= ? AND due_date < ?', today, today + length)
  end

  def self.due_today
    self.due_soon(1.day)
  end

  def self.is_overdue
    :issued && :due_date&.past?
  end
end
