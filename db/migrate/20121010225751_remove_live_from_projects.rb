class RemoveLiveFromProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :live
  end

  def down
    add_column :projects, :live, :boolean
  end
end
