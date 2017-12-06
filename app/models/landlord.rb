class Landlord < ApplicationRecord
  belongs_to :user
  has_many :contacts, as: :contactable
  has_many :properties
end
