class Landlord < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :properties, dependent: :restrict_with_exception
end
