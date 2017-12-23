class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table    :contacts do |t|
      t.belongs_to  :contactable, polymorphic: true, index: true
      t.string      :title
      t.string      :first_name
      t.string      :last_name
      t.string      :role
      t.string      :email, nullable: true
      t.string      :phone, nullable: true
      t.string      :address, nullable: true
      t.boolean     :primary, null: false, default: false
      t.timestamps
    end
  end
end
