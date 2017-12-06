class Utility < ApplicationRecord
  has_and_belongs_to_many :charge_schemes
  has_many :utility_charges
end
