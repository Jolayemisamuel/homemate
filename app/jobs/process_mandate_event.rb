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

require 'homemate/exception'

class ProcessMandateEvent < ProcessEvent
  def update(mandate, event)
    mandate.status_message = event['action']
    mandate.status_details = json_encode(event['details'])

    if event['action'].in? %w[created customer_approval_granted submitted active reinstated transferred]
      mandate.active = true unless mandate.active?
    elsif event['action'].in? %w[cancelled failed expired resubmission_requested]
      mandate.active = false if mandate.active?
    elsif event['action'] == 'replaced'
      mandate.active = true unless mandate.active?
      mandate.reference = event['links']['new_mandate']
    else
      raise HomeMate::InvalidUsage 'Action unknown for the specified resource type.'
    end

    mandate.save!
  end

  def process(event)
    super

    mandate = Mandate.where(reference: event['links']['mandate']).first
    update(mandate, event) unless mandate.empty?
  end

  private

  def resource_type
    'mandates'
  end
end