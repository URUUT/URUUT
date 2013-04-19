class AddCultivationImageToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :cultivation_image, :string
  end
end
