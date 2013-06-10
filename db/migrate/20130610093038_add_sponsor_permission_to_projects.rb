class AddSponsorPermissionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sponsor_permission, :boolean, default: true
  end
end
