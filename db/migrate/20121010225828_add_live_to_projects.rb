class AddLiveToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :live, :boolean, :default => false
  end
end
