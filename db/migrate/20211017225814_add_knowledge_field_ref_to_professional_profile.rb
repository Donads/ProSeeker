class AddKnowledgeFieldRefToProfessionalProfile < ActiveRecord::Migration[6.1]
  def change
    add_reference :professional_profiles, :knowledge_field, null: false, foreign_key: true
  end
end
