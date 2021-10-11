class CreateProjectProposals < ActiveRecord::Migration[6.1]
  def change
    create_table :project_proposals do |t|
      t.string :reason
      t.decimal :hourly_rate
      t.integer :weekly_hours
      t.date :deadline
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
