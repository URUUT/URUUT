class Milestoneemail < ActiveRecord::Base
  attr_accessible :fifteen_percent, :fifty_percent, :ninety_percent, :project_id, :seventy_five_percent
  has_many :projects
  
  def self.send_milestone_email(email, percent, project)
    MilestoneMailer.milestone_email(email, percent, project).deliver
  end
end
