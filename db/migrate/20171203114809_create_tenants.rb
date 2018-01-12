class CreateTenants < ActiveRecord::Migration[5.1]
  def change
    create_table      :tenants do |t|
      t.string        :name
      t.text          :public_key, nullable: true
      t.text          :private_key, nullable: true
      t.timestamps
    end
  end
end
