class CreateUserAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_associations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :associable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
