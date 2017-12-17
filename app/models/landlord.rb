class Landlord < ApplicationRecord
  has_many :user_associations, as: :associable, dependent: :restrict_with_exception
  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :properties, dependent: :restrict_with_exception
end
