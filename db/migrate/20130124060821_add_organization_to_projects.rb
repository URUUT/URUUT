class AddOrganizationToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :organization, :string
  end
end
