class ProjectUpdate < ActiveRecord::Base
  attr_accessible :content, :project_id, :title
  validates :content, :project_id, :title, presence: true
  belongs_to :project
end
