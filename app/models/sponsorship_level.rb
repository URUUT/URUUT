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

  DEFAULT_COST_PERCENTS = HashWithIndifferentAccess.new({
    platinum: 0.25,
    gold: 0.10,
    silver: 0.05,
    bronze: 0.02    
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

  def self.default_costs(index, project)
    unless index === 'bronze'
      return project.goal.gsub(/,/, '').to_i * DEFAULT_COST_PERCENTS[index]
    end
    if project.goal.gsub(/,/, '').to_i * 0.02 < 750
      project.goal.gsub(/,/, '').to_i * 0.02
    else
      750
    end
  end

  def calculated_cost(project)
    return SponsorshipLevel.default_costs(name, project) if DEFAULT_NAMES[name]
    cost
  end

end