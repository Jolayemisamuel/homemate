class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :lockable, :validatable

  has_one :user_association

  def is_tenant?
    user_association.associable.is_a? Tenant
  end

  def is_landlord?
    user_association.associable.is_a? Landlord
  end
end
