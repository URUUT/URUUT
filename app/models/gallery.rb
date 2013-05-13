class Gallery < ActiveRecord::Base
  attr_accessible :project_id, :gallery, :gallery_file_name, :gallery_content_type, :gallery_file_size
  belongs_to :project
  has_attached_file :gallery
    #:styles => { :large => "640x480", :medium => "300x300>", :thumb => "100x100>" }
end
