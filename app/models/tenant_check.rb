class TenantCheck < ApplicationRecord
  belongs_to :tenant

  def self.valid
    if :expires
      return :expires.past?
    else
      return true
    end
  end
end
