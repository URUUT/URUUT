class SponsorshipBenefit < ActiveRecord::Base
  attr_accessible :name, :sponsorship_level_id, :project_id, :status, :cost

  belongs_to :project
  belongs_to :sponsorship_level

  SPONSORSHIP_BENEFITS = {1 => [{ id: 1,  desc: "Recognition plaque or monument sign on project site."},
                          {id: 2, desc: "Platinum Sponsor mention on all external communication (press releases, community newsletter, etc.)"},
                          {id: 3, desc: "Profile of your company on our website with photo."},
                          {id: 4, desc: "Weekly plug on social media leading up to the project and the month after the project has been completed."},
                          {id: 5, desc: "Twenty tickets to VIP Gala Event."}],
                          2 => [{ id: 1, desc: "Gold Sponsor mention in community newsletter."},
                          {id: 2, desc: "Profile of your company on our website with photo."},
                          {id: 3, desc: "Bi-monthly plug on social media leading up to the project and the month after the project has been complete."},
                          {id: 4, desc: "Ten tickets to VIP Gala Event."}],
                          3 => [{id: 1, desc: "Profile of your company on our website with photo."},
                          {id: 2, desc: "Monthly plug on social media leading up to the project and the month after the project has been complete."},
                          {id: 3, desc: "Five tickets to VIP Gala Event."}],
                          4 => [{id: 1, desc: "Lorem ipsum dolor sit amet."}]}

  scope :for_project, ->(project) { where(project_id: project.id) }
  scope :actives, -> { where(status: true) }
  scope :with_project_sponsor_level, ->(project_sponsor) { where(sponsorship_level_id: project_sponsor.level_id) }
  scope :by_sponsorship_level_id, ->(id) { where(sponsorship_level_id: id) }
  scope :platinum, -> { by_sponsorship_level_id(1) }
  scope :gold,     -> { by_sponsorship_level_id(2) }
  scope :silver,   -> { by_sponsorship_level_id(3) }
  scope :bronze,   -> { by_sponsorship_level_id(4) }

  def self.modify_benefits_of_level(name, project, level)
    old_level_id = SponsorshipLevel::DEFAULT_NAMES[ name ]
    benefits = where(sponsorship_level_id: old_level_id, project_id: project)
    benefits.each do |b|
      b.sponsorship_level_id = level.id
      b.save!
    end
  end

  def self.sponsorship_level_ids(project)
    for_project(project).actives.group(:sponsorship_level_id).pluck(:sponsorship_level_id)
  end

  def self.default_plus_level(project, level_id, parent_id)
    benefits = for_project(project).by_sponsorship_level_id(level_id)
    rtn = []
    SponsorshipBenefit::SPONSORSHIP_BENEFITS[parent_id].each do |benefit|
      rtn << benefit unless benefits.find_index { |x| x.name == benefit[:desc] }
    end
    rtn + benefits
  end

end
