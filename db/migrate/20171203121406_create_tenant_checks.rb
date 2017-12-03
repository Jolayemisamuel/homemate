class CreateTenantChecks < ActiveRecord::Migration[5.1]
  def change
    create_table    :tenant_checks do |t|
      t.belongs_to  :tenant
      t.date        :expires, nullable: true
      t.timestamps
    end
  end
end
