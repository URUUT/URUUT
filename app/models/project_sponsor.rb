class ProjectSponsor < ActiveRecord::Base
  mount_uploader :logo, LogoUploader

  attr_accessible :card_token, :cost, :logo, :mission, :name, :project_id, :sponsor_id, :level_id, :payment, :status, :card_type, :card_last4

  belongs_to :project
  belongs_to :sponsor
  belongs_to :sponsorship_level, foreign_key: :level_id

  validates :name, :logo, :mission, :level_id, presence: true

  validates_length_of :mission, maximum: 275
end
