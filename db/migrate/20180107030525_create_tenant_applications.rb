class CreateTenantApplications < ActiveRecord::Migration[5.1]
  def change
    create_table    :tenant_applications do |t|
      t.belongs_to  :tenant, index: true
      t.boolean     :contact_completed, nullable: false, default: false
      t.boolean     :form_uploaded, nullable: false, default: false
      t.boolean     :reference_received, nullable: false, default: false
      t.boolean     :reference_passed
      t.boolean     :check_completed, nullable: false, default: false
      t.boolean     :mandate_completed, nullable: false, default: false
      t.boolean     :completed, nullable: false, default: false
      t.timestamps
    end
  end
end
