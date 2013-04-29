class ProjectSponsor < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  attr_accessible :card_token, :cost, :logo, :mission, :name, :project_id, :sponsor_id, :level_id

  belongs_to :project
  belongs_to :sponsor
end
