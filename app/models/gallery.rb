class Gallery < ActiveRecord::Base
  attr_accessible :project_id, :gallery, :gallery_file_name, :gallery_type
  belongs_to :project

  scope :media_transparent_room, lambda { |page_num| where(gallery_type: "transparency_workroom").page(page_num).per(9) }
end
