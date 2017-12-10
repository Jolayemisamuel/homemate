class Mandate < ApplicationRecord
  belongs_to :tenant
  has_many :transactions, as: :transactionable
end
