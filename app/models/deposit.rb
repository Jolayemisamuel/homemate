class Deposit < ApplicationRecord
  belongs_to :tenant
  belongs_to :tenancy
  has_one :transaction, as: :transactionable
  has_many :documents, as: :attachable
end
