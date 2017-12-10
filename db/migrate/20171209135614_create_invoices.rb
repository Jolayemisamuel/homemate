class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.belongs_to  :tenant
      t.boolean     :issued, null: false, default: false
      t.date        :due_on, nullable: true
      t.numeric     :balance
      t.timestamps
    end
  end
end
