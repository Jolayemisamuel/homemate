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

class Invoice < ApplicationRecord
  include Hashid::Rails

  belongs_to :tenant
  has_many :transactions
  has_many :documents, as: :attachable

  after_create after_create

  validates :balance, numericality: true
  validates :issued_on, presence: true, if: :issued
  validates :issued, inclusion: { in: [true, false] }

  def self.overdue
    where('issued = TRUE AND paid = FALSE AND due_on IS NOT NULL AND due_on < ?', Date.current)
  end

  def self.due_soon(length = 3.days)
    today = Date.current
    where('issued = TRUE AND paid = FALSE AND due_on IS NOT NULL AND due_on >= ? AND due_on < ?',
      today, today + length)
  end

  def self.due_today
    self.due_soon(1.day)
  end

  def is_overdue?
    !paid && issued && due_on&.past?
  end

  def balance_in_credit?
    balance < 0
  end

  def readable_balance
    Settings.currency + balance.abs
  end

  private

  def after_create
    unless tenant.mandates.empty?
      if (payment = tenant.mandates.first.schedule_payment(self))
        transaction = tenant.transactions.new(
          amount: balance * -1,
          description: 'Payment via GoCardless',
          external_referece: payment.id,
          tenancy: tenant.active_tenancy,
          payment: true,
          queued: false,
          processed: false
        )
        transaction.save!
      end
    end
  end
end
