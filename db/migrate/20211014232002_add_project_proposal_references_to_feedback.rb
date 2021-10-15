class AddProjectProposalReferencesToFeedback < ActiveRecord::Migration[6.1]
  def change
    add_reference :feedbacks, :project_proposal, null: false, foreign_key: true
  end
end
