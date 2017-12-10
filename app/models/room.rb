class Room < ApplicationRecord
  belongs_to :property
  has_many :tenancies, as: :rentable, dependent: :restrict_with_exception
  has_many :tenants, through: :tenancies
  has_many :utilities, through: :property
  has_many :utility_usages, through: :property
  has_many :utility_charges, through: :property

  default_scope {where(active: true)}

  def self.occupied
    if defined? :occupied_override
      return :occupied_override
    else
      return :tenancies.active.present?
    end
  end
end
