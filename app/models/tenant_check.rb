require 'active_support/core_ext/date'

class TenantCheck < ApplicationRecord
  belongs_to :tenant

  def self.valid
    if :expires
      return :expires.future?
    else
      return true
    end
  end
end
