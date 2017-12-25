class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.belongs_to  :tenant, index: true
      t.belongs_to  :invoice, index: true, nullable: true
      t.numeric     :amount
      t.string      :description
      t.string      :external_reference, nullable: true
      t.belongs_to  :tenancy, nullable: true
      t.boolean     :payment, null: false, default: false
      t.boolean     :processed, null: false, default: true
      t.date        :credit_date, nullable: true
      t.boolean     :failed, null: false, default: false
      t.string      :failure_message, nullable: true
      t.timestamps
    end
  end
end
