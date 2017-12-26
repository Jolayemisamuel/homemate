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

class GenerateInvoicesJob < ApplicationJob
  def perform
    process_monthly
    process_weekly
  end

  def process_monthly
    payment_date = Date.current + 14.days
    payment_day = payment_date.strftime('%e')

    if payment_day.in? 1..28
      tenancies = Tenancy.active.where(rent_payment_period: 'm').where(rent_payment_day: payment_day)

      tenancies.each do |t|
        GenerateInvoiceJob.perform_later(t, payment_date, true)
      end
    end
  end

  def process_weekly
    payment_date = Date.current + 7.days
    payment_day = payment_date.strftime('%u')

    tenancies = Tenancy.active.where(rent_payment_period: 'w').where(rent_payment_day: payment_day)

    tenancies.each do |t|
      GenerateInvoiceJob.perform_later(t, payment_date, false)
    end
  end
end