class CreateTenants < ActiveRecord::Migration[5.1]
  def change
    create_table      :tenants do |t|
      t.string        :name
      t.timestamps
    end

    create_join_table :tenants, :contacts do |t|
      t.index         :tenant_id
      t.index         :contact_id
    end
  end
end
