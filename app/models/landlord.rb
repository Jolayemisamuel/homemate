class Landlord < ApplicationRecord
  has_many :user_associations, as: :associable, dependent: :restrict_with_exception
  has_many :users, through: :user_associations
  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :properties, dependent: :restrict_with_exception
  has_many :rooms, through: :properties
  has_many :utilities, through: :properties

  validates :name, presence: true
end
