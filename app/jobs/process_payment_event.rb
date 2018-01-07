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

class ProcessPaymentEvent < ProcessEvent
  def update(transaction, event)
    case event['action']
      when 'created', 'customer_approval_granted'
        return
      when 'resubmission_requested'
        transaction.queued = false
        transaction.failed = false
      when 'customer_approval_denied', 'cancelled'
        transaction.failed = true
        transaction.message = json_encode(event['details'])
      when 'submitted'
        transaction.queued = true
      when 'confirmed', 'chargeback_cancelled', 'paid_out'
        transaction.processed = true
        transaction.failed = false
      when 'failed', 'charged_back', 'late_failure_settled', 'chargeback_settled'
        transaction.processed = true
        transaction.failed = true
        transaction.message = json_encode(event['details'])
      else
        raise HomeMate::InvalidUsage 'Action unknown for the specified resource type.'
    end

    transaction.save!
  end

  def process(event)
    super

    transaction = Transaction.where(payment: true).where(external_reference: event['links']['payment']).first
    update(transaction, event) unless transaction.empty?
  end

  private

  def resource_type
    'payments'
  end
end