class CreateProfessionalProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :professional_profiles do |t|
      t.string :full_name
      t.string :social_name
      t.string :description
      t.date :birth_date
      t.string :professional_qualification
      t.string :professional_experience

      t.timestamps
    end
  end
end
