class AddStatusDateFieldToProjectProposal < ActiveRecord::Migration[6.1]
  def change
    add_column :project_proposals, :status_date, :datetime
  end
end
