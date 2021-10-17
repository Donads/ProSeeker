class CreateKnowledgeFields < ActiveRecord::Migration[6.1]
  def change
    create_table :knowledge_fields do |t|
      t.string :title

      t.timestamps
    end
  end
end
