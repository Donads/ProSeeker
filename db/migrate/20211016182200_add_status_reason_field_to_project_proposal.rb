class AddStatusReasonFieldToProjectProposal < ActiveRecord::Migration[6.1]
  def change
    add_column :project_proposals, :status_reason, :string
  end
end
