class AddApprovalDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :approval_date, :string
  end
end
