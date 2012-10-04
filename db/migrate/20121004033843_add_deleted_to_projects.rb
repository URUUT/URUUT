class AddDeletedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :deleted, :boolean, :default => false
  end
end
