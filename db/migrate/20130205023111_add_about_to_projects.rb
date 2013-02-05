class AddAboutToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :about, :string
  end
end
