class AddProjectTitleToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_title, :string
  end
end
