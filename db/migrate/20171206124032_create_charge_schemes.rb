class CreateChargeSchemes < ActiveRecord::Migration[5.1]
  def change
    create_table      :charge_schemes do |t|
      t.timestamps
    end

    create_join_table :charge_schemes, :utilities do |t|
      t.index         :charge_scheme_id
      t.index         :utility_id
    end
  end
end
