class UtilityCharge < ApplicationRecord
  belongs_to :utility
  belongs_to :usage_from, :class_name => 'UtilityUsage', :foreign_key => :usage_from_id
  belongs_to :usage_to, :class_name => 'UtilityUsage', :foreign_key => :usage_to_id
  has_many :transactions, as: :transactionable
end
