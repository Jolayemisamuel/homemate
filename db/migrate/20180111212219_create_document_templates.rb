class CreateDocumentTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table    :document_templates do |t|
      t.string      :name
      t.text        :variables, nullable: true
      t.string      :file_type
      t.string      :file_path
      t.timestamps
    end
  end
end
