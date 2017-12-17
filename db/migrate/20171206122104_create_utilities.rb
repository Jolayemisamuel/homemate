class CreateUtilities < ActiveRecord::Migration[5.1]
  def change
    create_table    :utilities do |t|
      t.belongs_to  :property, index: true
      t.string      :name
      t.string      :provider_name
      t.boolean     :prepay_charges, null: false, default: false
      t.timestamps
    end
  end
end
