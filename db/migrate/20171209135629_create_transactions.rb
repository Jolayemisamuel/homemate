class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.belongs_to  :invoice, index: true
      t.numeric     :amount
      t.string      :description
      t.string      :external_reference, nullable: true
      t.belongs_to  :transactionable, polymorphic: true, index: {:name => 'index_transactions_on_transactionable'},
                    nullable: true
      t.boolean     :processed, null: false, default: true
      t.date        :credit_date, nullable: true
      t.boolean     :failed, null: false, default: false
      t.string      :failure_message, nullable: true
      t.timestamps
    end
  end
end
