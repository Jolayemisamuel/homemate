require 'active_support/core_ext/date'

class UtilityCharge < ApplicationRecord
  belongs_to :utility
  belongs_to :usage_from, :class_name => 'UtilityUsage', :foreign_key => :usage_from_id
  belongs_to :usage_to, :class_name => 'UtilityUsage', :foreign_key => :usage_to_id

  def self.ago(length = 1.month)
    where('date > ?', Date.current - length)
  end
end
