class Utility < ApplicationRecord
  belongs_to :property
  has_many :utility_prices, inverse_of: :utility, dependent: :destroy
  has_many :utility_usages, dependent: :restrict_with_exception
  has_many :utility_charges, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :provider_name, presence: true
  validates :included_in_rent, inclusion: { in: [true, false] }
  validates :prepay_charges, inclusion: { in: [true, false] }

  def usage_based
    joins(:utility_prices).where(utility_prices: {usage_based: true})
  end
end
