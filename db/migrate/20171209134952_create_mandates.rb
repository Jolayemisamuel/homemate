class CreateMandates < ActiveRecord::Migration[5.1]
  def change
    create_table :mandates do |t|
      t.belongs_to  :tenant, index: true
      t.string      :method
      t.string      :reference
      t.boolean     :active, null: false, default: true
      t.string      :last_message, nullable: true
      t.date        :last_success, nullable: true
      t.timestamps
    end
  end
end
