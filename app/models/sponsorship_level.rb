class SponsorshipLevel < ActiveRecord::Base
  attr_accessible :name, :cost, :description, :required, :funding_goal, :project_id

  belongs_to :project
  has_many :sponsorship_benefits

  DEFAULT_NAMES = HashWithIndifferentAccess.new({
    platinum: 1,
    gold: 2,
    silver: 3,
    bronze: 4
    })
end
