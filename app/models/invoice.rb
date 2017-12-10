require 'active_support/core_ext/date'

class Invoice < ApplicationRecord
  belongs_to :tenant
  has_many :transactions
  has_many :documents, as: :attachable

  validates :balance, numericality: true

  def self.overdue
    if :due_date
      return :due_date.past?
    else
      return false
    end
  end
end
