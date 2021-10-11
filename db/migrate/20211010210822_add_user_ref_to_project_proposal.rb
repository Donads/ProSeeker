class AddUserRefToProjectProposal < ActiveRecord::Migration[6.1]
  def change
    add_reference :project_proposals, :user, null: false, foreign_key: true
  end
end
