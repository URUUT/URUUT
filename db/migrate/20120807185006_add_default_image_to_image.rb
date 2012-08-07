class AddDefaultImageToImage < ActiveRecord::Migration
  def change
    add_column :images, :project_image_processing, :string
  end
end
