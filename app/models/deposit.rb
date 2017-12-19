class Deposit < ApplicationRecord
  belongs_to :tenant
  belongs_to :tenancy
  has_one :transaction, as: :transactionable

  default_scope {where(refunded: false)}
end
