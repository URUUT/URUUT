class AddPerkPermissionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :perk_permission, :boolean
  end
end
