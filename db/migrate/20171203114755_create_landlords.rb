class CreateLandlords < ActiveRecord::Migration[5.1]
  def change
    create_table      :landlords do |t|
      t.string        :name
      t.timestamps
    end

    add_index :landlords, :name, unique: true
  end
end
