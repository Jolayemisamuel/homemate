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

require 'active_support/core_ext/string'
require 'homemate/exception'

class ProcessEvent < ApplicationJob
  def process(event)
    unless event['resource_type'] == resource_type
      raise HomeMate::InvalidUsage 'Invalid event resource type. ' + resource_type.titleize + ' expected.'
    end

    logger.notice 'Event received from GoCardless'
  end

  private

  def resource_type
    'type'
  end
end