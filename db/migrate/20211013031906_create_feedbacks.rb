class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.decimal :score
      t.string :user_feedback
      t.string :project_feedback
      t.references :project, null: false, foreign_key: true
      t.integer :feedback_creator_id
      t.integer :feedback_receiver_id

      t.timestamps
    end
  end
end
