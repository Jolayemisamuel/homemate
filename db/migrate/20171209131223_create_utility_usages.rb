class CreateUtilityUsages < ActiveRecord::Migration[5.1]
  def change
    create_table :utility_usages do |t|
      t.belongs_to  :utility
      t.date        :date
      t.numeric     :reading
      t.boolean     :projected, null: false, default: false
    end
  end
end
