class ProjectSponsor < ActiveRecord::Base
  attr_accessible :card_token, :cost, :logo, :mission, :name, :project_id, :sponsor_id, :level_id
  attr_accessor :level_id

  belongs_to :project
  belongs_to :sponsor
end
