class Deposit < ApplicationRecord
  belongs_to :tenant
  belongs_to :tenancy

  default_scope {where(refunded: false)}
end
