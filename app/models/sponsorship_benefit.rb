class SponsorshipBenefit < ActiveRecord::Base
  attr_accessible :name, :sponsorship_level_id

  belongs_to :sponsorship_level
end
