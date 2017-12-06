class ChargeScheme < ApplicationRecord
  has_and_belongs_to_many :utilities
  has_many :tenancies
end
