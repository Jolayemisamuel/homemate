class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table    :rooms do |t|
      t.string      :name
      t.belongs_to  :property, index: true
      t.numeric     :size
      t.numeric     :charge_weight
      t.boolean     :active
      t.timestamps
    end
  end
end
