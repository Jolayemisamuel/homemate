class Property < ApplicationRecord
  belongs_to :landlord
  has_many :tenancies, as: :rentable
  has_many :tenants, through: :tenancies
  has_many :rooms
end
