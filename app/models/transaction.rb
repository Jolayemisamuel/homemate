class Transaction < ApplicationRecord
  belongs_to :tenant
  belongs_to :invoice, optional: true
  belongs_to :tenancy

  default_scope { where(processed: true) }

  validates :amount, numericality: true
  validates :description, presence: true
  validates :processed, inclusion: { in: [true, false] }

  def in_credit?
    amount < 0
  end

  def readable_amount
    Settings.currency + amount.abs
  end
end
