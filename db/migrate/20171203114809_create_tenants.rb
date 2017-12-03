class CreateTenants < ActiveRecord::Migration[5.1]
  def change
    create_table    :tenants do |t|
      t.timestamps
    end

    create_join_table :tenants, :users do |t|
      t.index :tenant_id
      t.index :user_id
    end
  end
end
