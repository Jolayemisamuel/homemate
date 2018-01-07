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

class Transaction < ApplicationRecord
  belongs_to :tenant
  belongs_to :invoice, required: false
  belongs_to :tenancy, required: false
  belongs_to :transactionable, polymorphic: true, required: false

  default_scope { where(processed: true).order(created_at: :desc) }

  validates :amount, numericality: true
  validates :description, presence: true
  validates :processed, inclusion: { in: [true, false] }

  def in_credit?
    amount < 0
  end

  def readable_amount
    Settings.payment.currency + amount.abs
  end
end
