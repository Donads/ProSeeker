class AddStatusToProjectProposal < ActiveRecord::Migration[6.1]
  def change
    add_column :project_proposals, :status, :integer, default: 10, null: false
  end
end
