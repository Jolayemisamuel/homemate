require 'active_support/core_ext/date'

class TenantCheck < ApplicationRecord
  belongs_to :tenant
  has_many :documents, as: :attachable

  validates :document_type, presence: true

  def self.valid
    where('expires >= ?', Date.current)
  end

  def self.expires_in(length = 1.month)
    today = Date.current
    where('expires IS NOT NULL AND expires >= ? AND expires < ?', today, today + length)
  end

  def is_valid?
    expires.today? || expires.future?
  end
end
