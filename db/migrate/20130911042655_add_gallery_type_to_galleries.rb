class AddGalleryTypeToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :gallery_type, :string
  end
end
