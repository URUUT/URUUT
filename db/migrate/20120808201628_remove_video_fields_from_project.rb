class RemoveVideoFieldsFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :project_video_updated_at
    remove_column :projects, :project_video_file_size
    remove_column :projects, :project_video_content_type
    remove_column :projects, :project_video_file_name
  end

  def down
    add_column :projects, :project_video_file_name, :string
    add_column :projects, :project_video_content_type, :string
    add_column :projects, :project_video_file_size, :integer
    add_column :projects, :project_video_updated_at, :datetime
  end
end
