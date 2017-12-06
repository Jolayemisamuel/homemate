class CreateTenants < ActiveRecord::Migration[5.1]
  def change
    create_table      :tenants do |t|
      t.name          :tenants
      t.timestamps
    end

    create_join_table :users, :tenants do |t|
      t.index         :user_id
      t.index         :tenant_id
    end

    create_join_table :tenants, :contacts do |t|
      t.index         :tenant_id
      t.index         :contact_id
    end
  end
end
