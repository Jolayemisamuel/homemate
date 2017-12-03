class CreateLandlords < ActiveRecord::Migration[5.1]
  def change
    create_table :landlords do |t|
      t.timestamps
    end

    create_join_table :landlords, :users do |t|
      t.index :landlord_id
      t.index :user_id
    end
  end
end
