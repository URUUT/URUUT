class AddLargeImageToProject < ActiveRecord::Migration
  def change
    add_column :projects, :large_image, :string
  end
end
