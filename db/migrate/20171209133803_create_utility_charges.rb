class CreateUtilityCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :utility_charges do |t|
      t.belongs_to  :utility, index: true
      t.numeric     :amount
      t.references  :usage_from, index: true, nullable: true
      t.references  :usage_to, index: true, nullable: true
      t.date        :usage_from_date
      t.date        :usage_to_date
      t.timestamps
    end

    add_foreign_key :utility_charges, :utility_usages, column: :usage_from_id
    add_foreign_key :utility_charges, :utility_usages, column: :usage_to_id
  end
end
