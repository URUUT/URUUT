class ProjectSponsor < ActiveRecord::Base
  attr_accessible :card_token, :cost, :logo, :mission, :name, :project_id
end
