class CreateUtilities < ActiveRecord::Migration[5.1]
  def change
    create_table    :utilities do |t|
      t.string      :name
      t.string      :provider_name
      t.timestamps
    end
  end
end
