class AddOrgInfoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :organization_type, :string
    add_column :projects, :organization_classification, :string
  end
end
