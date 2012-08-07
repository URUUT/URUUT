class AddAttachmentProjectVideoToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.has_attached_file :project_video
    end
  end

  def self.down
    drop_attached_file :projects, :project_video
  end
end
