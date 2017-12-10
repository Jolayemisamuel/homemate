class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.belongs_to  :invoice, index: true
      t.numeric     :amount
      t.string      :description
      t.string      :external_reference, nullable: true
      t.belongs_to  :transactionable, polymorphic: true, index: true, nullable: true
      t.timestamps
    end
  end
end
