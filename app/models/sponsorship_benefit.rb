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
  scope :with_project_sponsor_level, ->(project_sponsor) { where(sponsorship_level_id: project_sponsor.level_id) }

  def self.modify_benefits_of_level(name, project, level)
    old_level_id = SponsorshipLevel::DEFAULT_NAMES[ name ]
    benefits = where(sponsorship_level_id: old_level_id, project_id: project)
    benefits.each do |b|
      b.sponsorship_level_id = level.id
      b.save!
    end
  end

  def self.sponsorship_level_ids(project)
    for_project(project).group(:sponsorship_level_id).pluck(:sponsorship_level_id)
  end
    
end
