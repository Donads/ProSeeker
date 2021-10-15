class RemoveProjectFromFeedbacks < ActiveRecord::Migration[6.1]
  def change
    remove_reference :feedbacks, :project, null: false, foreign_key: true
  end
end
