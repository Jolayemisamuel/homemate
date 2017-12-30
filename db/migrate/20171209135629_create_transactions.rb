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

class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.belongs_to  :tenant, index: true
      t.belongs_to  :invoice, index: true, nullable: true
      t.numeric     :amount
      t.string      :description
      t.string      :external_reference, nullable: true
      t.belongs_to  :tenancy, index: true, nullable: true
      t.belongs_to  :transactionable, polymorphic: true, index: {:name => 'index_transactions_on_transactionable'},
        nullable: true
      t.boolean     :payment, null: false, default: false
      t.boolean     :queued, null: false, default: true
      t.boolean     :processed, null: false, default: true
      t.date        :credit_date, nullable: true
      t.boolean     :failed, null: false, default: false
      t.string      :message, nullable: true
      t.timestamps
    end
  end
end
