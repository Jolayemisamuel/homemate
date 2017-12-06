require 'active_support/core_ext/date'

class Tenancy < ApplicationRecord
  belongs_to :rentable, polymorphic: true
  belongs_to :tenant
  has_many :documents, as: :attachable
  belongs_to :charge_scheme

  validates :start_date, presence: true

  def self.active
    if :end_date
      return :start_date.past? && :end_date.future?
    else
      return :start_date.past?
    end
  end
end
