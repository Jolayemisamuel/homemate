class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :trackable, :lockable, :validatable

  has_one :user_association
  has_one :landlord, through: :user_association, source: :associable, source_type: 'Landlord'
  has_one :tenant, through: :user_association, source: :associable, source_type: 'Tenant'

  def is_tenant?
    user_association.associable.is_a? Tenant
  end

  def is_landlord?
    user_association.associable.is_a? Landlord
  end
end
