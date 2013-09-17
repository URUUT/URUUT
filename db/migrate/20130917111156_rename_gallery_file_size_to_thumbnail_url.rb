class RenameGalleryFileSizeToThumbnailUrl < ActiveRecord::Migration
  def change
    remove_column :galleries, :gallery_file_size
    add_column :galleries, :thumbnail_url, :string
  end
end
