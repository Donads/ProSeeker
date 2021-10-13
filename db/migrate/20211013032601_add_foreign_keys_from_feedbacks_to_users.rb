class AddForeignKeysFromFeedbacksToUsers < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :feedbacks, :users, column: :feedback_creator_id
    add_foreign_key :feedbacks, :users, column: :feedback_receiver_id

    change_column_null(:feedbacks, :feedback_creator_id, false)
    change_column_null(:feedbacks, :feedback_receiver_id, false)
  end
end
