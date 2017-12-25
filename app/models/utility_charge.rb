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

require 'active_support/core_ext/date'

class UtilityCharge < ApplicationRecord
  belongs_to :utility
  belongs_to :usage_from, :class_name => 'UtilityUsage', :foreign_key => :usage_from_id
  belongs_to :usage_to, :class_name => 'UtilityUsage', :foreign_key => :usage_to_id
  has_one :transaction, as: :transactionable, required: false

  def self.ago(length = 1.month)
    where('date > ?', Date.current - length)
  end
end
