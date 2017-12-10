require 'active_support/core_ext/date'

class Tenancy < ApplicationRecord
  belongs_to :rentable, polymorphic: true
  belongs_to :tenant
  has_many :documents, as: :attachable
  has_many :transactions, as: :transactionable
  has_one :deposit

  validates :rent, numericality: true
  validates :start_date, presence: true

  def self.active
    if :end_date
      return :start_date.past? && :end_date.future?
    else
      return :start_date.past?
    end
  end
end
