class AddFeedbackSourceToFeedback < ActiveRecord::Migration[6.1]
  def change
    add_column :feedbacks, :feedback_source, :integer, null: false
  end
end
