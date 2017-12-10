class CreateUtilityPrices < ActiveRecord::Migration[5.1]
  def change
    create_table    :utility_prices do |t|
      t.string      :name
      t.belongs_to  :utility, index: true
      t.numeric     :price
      t.boolean     :usage_based
      t.string      :usage_unit, nullable: true
      t.string      :length_unit, nullable: true, length: 1
      t.timestamps
    end
  end
end
