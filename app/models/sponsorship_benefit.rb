class SponsorshipBenefit < ActiveRecord::Base
  attr_accessible :name, :sponsorship_level_id, :project_id, :status, :cost

  belongs_to :project

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
end
