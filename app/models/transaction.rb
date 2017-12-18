class Transaction < ApplicationRecord
  belongs_to :tenant
  belongs_to :invoice, optional: true
  belongs_to :transactionable, polymorphic: true
end
