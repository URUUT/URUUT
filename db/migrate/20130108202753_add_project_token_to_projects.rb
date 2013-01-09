class AddProjectTokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :project_token, :string
  end
end
