class UtilityUsage < ApplicationRecord
  belongs_to :utility

  validates :date, presence: true
end
