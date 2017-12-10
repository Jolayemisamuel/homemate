class CreateTenancies < ActiveRecord::Migration[5.1]
  def change
    create_table    :tenancies do |t|
      t.references  :rentable, polymorphic: true, index: true
      t.belongs_to  :tenant, index: true
      t.numeric     :rent
      t.string      :rent_period, null: false, default: 'm', length: 1
      t.integer     :rent_payment_day, null: false, default: 1
      t.date        :start_date
      t.date        :end_date, nullable: true
      t.timestamps
    end
  end
end
