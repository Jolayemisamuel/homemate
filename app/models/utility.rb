class Utility < ApplicationRecord
  belongs_to :property
  has_many :utility_prices
  has_many :utility_usages

  validates :name, presence: true
end
