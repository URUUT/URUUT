class AddReadyForApprovalToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :ready_for_approval, :integer
  end
end
