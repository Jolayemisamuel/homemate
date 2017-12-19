require 'active_support/core_ext/date'

class Invoice < ApplicationRecord
  belongs_to :tenant
  has_many :transactions
  has_many :documents, as: :attachable

  validates :balance, numericality: true
  validates :issued_on, presence: true, if: :issued
  validates :issued, inclusion: { in: [true, false] }

  def self.overdue
    where('issued = TRUE AND paid = FALSE AND due_on IS NOT NULL AND due_on < ?', Date.current)
  end

  def self.due_soon(length = 3.days)
    today = Date.current
    where('issued = TRUE AND paid = FALSE AND due_on IS NOT NULL AND due_on >= ? AND due_on < ?',
      today, today + length)
  end

  def self.due_today
    self.due_soon(1.day)
  end

  def is_overdue?
    !paid && issued && due_on&.past?
  end

  def balance_in_credit?
    balance < 0
  end

  def readable_balance
    Settings.currency + balance.abs
  end
end
