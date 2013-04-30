class ProjectSponsor < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  attr_accessible :card_token, :cost, :logo, :mission, :name, :project_id, :sponsor_id, :level_id, :payment, :status

  belongs_to :project
  belongs_to :sponsor

  validates :name, :logo, :mission, :level_id, presence: true

  validates_length_of :mission, maximum: 275
end
