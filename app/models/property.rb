class Property < ApplicationRecord
  belongs_to :landlord
  has_many :rooms, dependent: :restrict_with_exception
  has_many :tenancies, as: :rentable, dependent: :restrict_with_exception
  has_many :tenants, through: :tenancies
  has_many :utilities, dependent: :destroy
  has_many :utility_usages, through: :utilities
  has_many :utility_charges, through: :utilities

  default_scope {where(active: true)}
end
