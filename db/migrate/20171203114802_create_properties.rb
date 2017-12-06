class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table    :properties do |t|
      t.string      :name
      t.belongs_to  :landlord, index: true
      t.string      :address
      t.string      :postcode
      t.numeric     :size
      t.boolean     :active
      t.timestamps
    end
  end
end
