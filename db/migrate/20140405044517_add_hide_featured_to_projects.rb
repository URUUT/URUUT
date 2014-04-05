class AddHideFeaturedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :hide_featured, :boolean, :default => false
  end
end
