class Property < ApplicationRecord
  belongs_to :landlord
  has_many :rooms
  has_many :tenancies, as: :rentable
  has_many :tenants, through: :tenancies
  has_many :utilities
  has_many :utility_usages, through: :utilities
end
