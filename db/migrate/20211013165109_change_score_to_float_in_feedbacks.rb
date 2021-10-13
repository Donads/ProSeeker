class ChangeScoreToFloatInFeedbacks < ActiveRecord::Migration[6.1]
  def change
    change_column :feedbacks, :score, :float
  end
end
