class CreateLandlords < ActiveRecord::Migration[5.1]
  def change
    create_table      :landlords do |t|
      t.string        :name
      t.timestamps
    end

    create_join_table :users, :landlords do |t|
      t.index         :user_id
      t.index         :landlord_id
    end

    create_join_table :landlords, :contacts do |t|
      t.index         :landlord_id
      t.index         :contact_id
    end
  end
end
