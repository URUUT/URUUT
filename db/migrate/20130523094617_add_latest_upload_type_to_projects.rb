class AddLatestUploadTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :seed_mime_type, :string, default: "image"
    add_column :projects, :cultivation_mime_type, :string, default: "image"

    Project.update_all(seed_video: "", cultivation_video: "") unless Project.all.blank?
  end
end
