class Room < ApplicationRecord
  belongs_to :property
  has_many :utilities, as: :rentable
  has_many :tenancies, as: :rentable
  has_many :tenants, through: :tenancies
  has_many :utilities, through: :property
  has_many :utility_usages, through: :property
end
