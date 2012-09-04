class Objective < ActiveRecord::Base
  attr_accessible :content, :project_id

  belongs_to :project
end
