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

  def self.by_project(project)
    joins(:sponsorship_benefits)
      .where("sponsorship_benefits.project_id = #{project.id}")
      .select('sponsorship_levels.name, sponsorship_levels.id, sponsorship_levels.parent_id')
      .group('sponsorship_levels.id')
      .order('sponsorship_levels.parent_id')
  end
end
