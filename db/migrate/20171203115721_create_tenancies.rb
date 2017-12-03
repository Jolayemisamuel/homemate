class CreateTenancies < ActiveRecord::Migration[5.1]
  def change
    create_table    :tenancies do |t|
      t.references  :rentable, polymorphic: true, index: true
      t.belongs_to  :tenant, index: true
      t.date        :start_date
      t.date        :end_date, nullable: true
      t.timestamps
    end
  end
end
