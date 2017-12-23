class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table    :users do |t|
      t.string      :username, index: true, unique: true
      t.string      :email, index: true, unique: true
      t.string      :encrypted_password, null: false, default: ""
      t.boolean     :is_admin, null: false, default: false
      t.belongs_to  :contact, index: true
      t.datetime    :remember_created_at
      t.integer     :sign_in_count, null: false, default: 0
      t.datetime    :current_sign_in_at
      t.datetime    :last_sign_in_at
      t.string      :current_sign_in_ip
      t.string      :last_sign_in_ip
      t.integer     :failed_attempts, null: false, default: 0
      t.datetime    :locked_at
      t.timestamps  null: false
    end
  end
end
