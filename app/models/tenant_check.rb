##
# Copyright (c) Andrew Ying 2017-18.
#
# This file is part of HomeMate.
#
# HomeMate is free software: you can redistribute it and/or modify
# it under the terms of version 3 of the GNU General Public License
# as published by the Free Software Foundation. You must preserve
# all reasonable legal notices and author attributions in this program
# and in the Appropriate Legal Notice displayed by works containing
# this program.
#
# HomeMate is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with HomeMate.  If not, see <http://www.gnu.org/licenses/>.
##

require 'active_support/core_ext/date'

class TenantCheck < ApplicationRecord
  belongs_to :tenant
  has_many :documents, as: :attachable

  validates :document_type, presence: true

  before_save :tenant_check_hook

  def self.valid
    where('expires >= ? OR expires IS NULL', Date.current)
  end

  def self.expires_in(length = 1.month)
    today = Date.current
    where('expires IS NOT NULL AND expires >= ? AND expires < ?', today, today + length)
  end

  def is_valid?
    expires.nil? || expires.today? || expires.future?
  end

  private

  def tenant_check_hook
    application = tenant.current_application

    if application.present?
      application.check_completed = true
    end
  end
end
