class SponsorshipLevel < ActiveRecord::Base
  attr_accessible :name, :cost, :description, :required, :funding_goal, :project_id, :parent_id

  belongs_to :project
  has_many :sponsorship_benefits
  belongs_to :parent, class_name: 'SponsorshipLevel'

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

  AVAILABILITY = HashWithIndifferentAccess.new({
    platinum: 1,
    gold: 3,
    silver: 5,
    bronze: 10
  })

  DEFAULT_SPONSORSHIP_LEVEL_PARAM = {
    'platinum' => { "name" => 'platinum' },
    'gold' => { "name" => 'gold' },
    'silver' => { "name" => 'silver' },
    'bronze' => { "name" => 'bronze' }
  }

  DEFAULT_AVAILITY = {
      1 => '(1 of 1 available)',
      2 => '(3 of 3 available)',
      3 => '(5 of 5 available)',
      4 => ''
    }

  scope :default_levels, where(id: [1,2,3,4])
  scope :by_parent, order(:parent_id)
  scope :without_ids, ->(ids) { where(id: ids) }

  def self.by_project(project)
    with_benefits = SponsorshipLevel.with_benefits(project)

    if with_benefits.any?
      with_benefits_ids = with_benefits.collect {|k,v| v.parent_id}
      default = SponsorshipLevel.default_levels.without_ids(with_benefits_ids)
      return (default | with_benefits.values).sort { |x,y| x.parent_id <=> y.parent_id }
    end
    SponsorshipLevel.default_levels
  end

  def self.with_benefits(project)
    ids = SponsorshipBenefit.sponsorship_level_ids(project)
    where(id: ids).by_parent.group_by {|level| level.parent_id}.
      reduce({}) { |memo,value| memo.merge({value[0] => value[1][0]}) }
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
    return SponsorshipLevel.default_costs(name.downcase, project) if DEFAULT_NAMES[name.downcase]
    cost
  end

  def self.create_custom(project, levels, params)
    SponsorshipBenefit.where(project_id: project.id).destroy_all
    levels.each_pair do |default_name, value|
      new_name = value['name'].downcase
      level = SponsorshipLevel::DEFAULT_NAMES[ new_name ]? find(SponsorshipLevel::DEFAULT_NAMES[ new_name ]) : false
      unless level
        level = SponsorshipLevel.new(value)
        level.parent_id = SponsorshipLevel::DEFAULT_NAMES[ default_name ]
        level.save!
      end
      if params["#{default_name}"]
        benefits = params["#{default_name}"].select { |key, value| key.to_i > 0 }
        benefits.each_pair do |key, value|
          unless params["#{default_name}"]["info_#{key}"].blank?
            new_benefit = SponsorshipBenefit.new({name: params["#{default_name}"]["info_#{key}"], sponsorship_level_id: level.id, project_id: project.id, status: 1})
            new_benefit.save!
          end
        end
      end
    end
    levels.to_a.compact
  end

end
