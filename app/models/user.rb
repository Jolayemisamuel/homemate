class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :lockable, :validatable

  has_and_belongs_to_many :tenants
  has_and_belongs_to_many :landlords
end
