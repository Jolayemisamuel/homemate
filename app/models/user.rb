class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :lockable, :validatable

  belongs_to :tenant
  belongs_to :landlord
end
