class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table    :documents do |t|
      t.string      :name
      t.references  :attachable, polymorphic: true, index: true
      t.string      :path
      t.boolean     :encrypted, null: false, default: false
      t.string      :iv, nullable: true
      t.timestamps
    end
  end
end
