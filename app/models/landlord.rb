class Landlord < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :contacts, as: :contactable
  has_many :properties
end
