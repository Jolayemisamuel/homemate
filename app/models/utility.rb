class Utility < ApplicationRecord
  belongs_to :property
  has_many :utility_prices, dependent: :destroy
  has_many :utility_usages, dependent: :restrict_with_exception
  has_many :utility_charges, dependent: :restrict_with_exception

  validates :name, presence: true
end
