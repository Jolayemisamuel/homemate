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

class Tenant < ApplicationRecord
  include CanOwnDocuments

  has_many :user_associations, as: :associable, dependent: :restrict_with_exception
  has_many :users, through: :user_associations
  has_many :contacts, as: :contactable, dependent: :destroy

  has_many :tenancies, dependent: :restrict_with_exception
  has_many :tenant_applications, dependent: :destroy
  has_many :tenant_checks, dependent: :destroy

  has_many :mandates, dependent: :destroy
  has_many :invoices
  has_many :transactions
  has_many :deposits

  attr_accessor :no_application
  validates :name, presence: true

  def balance
    transactions.where(processed: true).where(failed: false).sum(:amount)
  end

  def last_invoice
    invoices.where(issued: true).order(issued_on: :desc).first
  end

  def readable_balance
    Settings.payment.currency + sprintf('%0.02f', balance.abs)
  end

  def balance_in_credit?
    balance < 0
  end

  def pending_balance
    transactions.sum(:amount)
  end

  def readable_pending_balance
    Settings.payment.currency + sprintf('%0.02f', pending_balance.abs)
  end

  def pending_balance_is_credit?
    pending_balance < 0
  end

  def current_application
    tenant_applications.where(completed: false).order(updated_at: :desc).first
  end

  def active_tenancy
    tenancies.active.first
  end

  def future_tenancies
    tenancies.future
  end

  def current_tenancy
    if active_tenancy.present?
      active_tenancy
    else
      future_tenancies.first
    end
  end

  def has_active_mandate?
    mandates.present?
  end
end
