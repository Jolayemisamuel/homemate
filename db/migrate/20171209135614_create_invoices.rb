class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.belongs_to  :tenant
      t.boolean     :issued, null: false, default: false
      t.date        :issued_on, nullale: true
      t.date        :due_on, nullable: true
      t.numeric     :balance
      t.boolean     :paid, null: false, default: false
      t.timestamps
    end
  end
end
