class Room < ApplicationRecord
  belongs_to :property
  has_many :tenancies, as: :rentable, dependent: :restrict_with_exception
  has_many :tenants, through: :tenancies
  has_many :utilities, through: :property
  has_many :utility_usages, through: :property
  has_many :utility_charges, through: :property

  validates_associated :property
  validates :name, presence: true
  validates :size, numericality: { greater_than: 0 }, allow_nil: true

  default_scope { where(active: true) }

  def is_occupied?
    if defined? occupied_override
      occupied_override
    else
      tenancies.active.present?
    end
  end
end
