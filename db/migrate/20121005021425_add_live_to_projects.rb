class AddLiveToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :live, :boolean
  end
end
