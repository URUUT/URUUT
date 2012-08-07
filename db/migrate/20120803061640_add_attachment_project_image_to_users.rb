class AddAttachmentProjectImageToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.has_attached_file :project_image
    end
  end

  def self.down
    drop_attached_file :users, :project_image
  end
end
