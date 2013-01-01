class Gallery < ActiveRecord::Base
  attr_accessible :project_id 
  belongs_to :project
  has_attached_file :gallery, :styles => { :large => "640x480", :medium => "300x300>", :thumb => "100x100>" }
end
