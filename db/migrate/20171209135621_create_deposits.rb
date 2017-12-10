class CreateDeposits < ActiveRecord::Migration[5.1]
  def change
    create_table      :deposits do |t|
      t.belongs_to    :tenancy, index: true
      t.numeric       :amount
      t.boolean       :refunded, null: false, default: false
      t.timestamps
    end
  end
end
