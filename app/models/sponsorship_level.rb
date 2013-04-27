class SponsorshipLevel < ActiveRecord::Base
  attr_accessible :name, :cost, :description, :required, :funding_goal, :project_id

  belongs_to :project
  has_many :sponsorship_benefits
end
