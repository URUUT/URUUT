class AddInfoToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :video_file_name, :string
    add_column :videos, :video_file_size, :integer
    add_column :videos, :video_content_type, :string
    add_column :videos, :video_updated_at, :datetime
  end
end
