class AddAttachmentProjectVideoToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.has_attached_file :project_video
    end
  end

  def self.down
    drop_attached_file :users, :project_video
  end
end
