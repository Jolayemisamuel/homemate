class Tenant < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :contacts, as: :contactable
  has_many :tenancies
  has_many :tenant_checks

  def self.current_tenancy
    return self.tenancies.order(:started_on).last
  end

end
