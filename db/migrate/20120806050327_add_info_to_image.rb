class AddInfoToImage < ActiveRecord::Migration
  def change
    add_column :images, :image_file_name, :string
    add_column :images, :image_file_size, :integer
    add_column :images, :image_content_type, :string
    add_column :images, :image_updated_at, :datetime
  end
end
