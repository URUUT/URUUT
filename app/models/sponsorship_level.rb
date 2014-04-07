class SponsorshipLevel < ActiveRecord::Base
  attr_accessible :name, :cost, :description, :required, :funding_goal, :project_id, :parent_id

  belongs_to :project
  has_many :sponsorship_benefits

  DEFAULT_NAMES = HashWithIndifferentAccess.new({
    platinum: 1,
    gold: 2,
    silver: 3,
    bronze: 4
    })

  scope :default_levels, where(id: [1,2,3,4])

  def self.by_project(project)
    with_benefits = SponsorshipLevel.where(id: SponsorshipBenefit.sponsorship_level_ids(project)).
      order(:parent_id)

    if with_benefits.any?
      default = SponsorshipLevel.default_levels.
                  where('id NOT IN (?)', with_benefits.pluck(:parent_id))
      return (default | with_benefits).sort { |x,y| x.parent_id <=> y.parent_id }
    end
    SponsorshipLevel.default_levels
  end
end
