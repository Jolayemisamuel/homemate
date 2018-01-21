##
# Copyright (c) Andrew Ying 2017.
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

require 'gocardless_pro'

class Mandate < ApplicationRecord
  belongs_to :tenant
  has_many :transactions, as: :transactionable

  default_scope {where(active: true)}

  before_save :tenant_check_hook

  # Schedule a GoCardless payment for the future
  #
  # @param [Invoice] invoice the invoice instance
  # @return [GoCardlessPro::Resources::Payment]
  def schedule_payment(invoice)
    begin
      gocardless_client.payments.create(
          params: {
              amount: invoice.balance * 100,
              currency: 'GBP',
              charge_date: invoice.due_on,
              description: Setting.payment.description,
              links: {
                  mandate: reference
              }
          }
      )
    rescue GoCardlessPro::InvalidStateError => error
      if error.type == 'mandate_is_inactive'
        self.cancelled = true
        self.save!
      end
      logger.warn '[Request ' + error.request_id + '] Invalid State Error: ' + error.message

      return nil
    rescue GoCardlessPro::GoCardlessError,
        GoCardlessPro::InvalidApiUsageError,
        GoCardlessPro::ValidationError => error
      logger.error '[Request ' + error.request_id + '] API Error: ' + error.message
      raise error
    end
  end

  private

  def tenant_check_hook
    application = tenant.current_application

    if application.present?
      application.mandate_completed = true
    end
  end

  def gocardless_client
    GoCardlessPro::Client.new(
        access_token: Setting.gocardless.token,
        environment: Setting.gocardless.env
    )
  end
end
