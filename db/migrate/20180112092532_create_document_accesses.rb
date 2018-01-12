class CreateDocumentAccesses < ActiveRecord::Migration[5.1]
  def change
    create_table     :document_accesses do |t|
      t.belongs_to   :document, index: true
      t.belongs_to   :owner, polymorphic: true, index: true
      t.text         :encrypted_secret
      t.timestamps
    end
  end
end
