class Transaction < ApplicationRecord
  belongs_to :invoice
  belongs_to :transactionable, polymorphic: true
end
