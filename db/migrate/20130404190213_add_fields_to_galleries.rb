class AddFieldsToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :gallery_file_name, :string
    add_column :galleries, :gallery_content_type, :string
    add_column :galleries, :gallery_file_size, :integer
    add_column :galleries, :gallery_updated_at, :datetime
    add_column :galleries, :project_id, :integer
  end
end
