class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table    :contacts do |t|
      t.string      :name
      t.string      :role
      t.string      :email, nullable: true
      t.string      :phone, nullable: true
      t.string      :address, nullable: true
      t.timestamps
    end
  end
end
