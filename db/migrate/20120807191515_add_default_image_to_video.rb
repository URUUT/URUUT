class AddDefaultImageToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :project_video_processing, :string
  end
end
