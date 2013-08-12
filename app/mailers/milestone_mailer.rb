class MilestoneMailer < ActionMailer::Base
  default from: "info@uruut.com"
  
  def milestone_email(email, percent, project)
  	  @email = email
  	  @percent = percent
  	  @project = project
  	  mail to: @email, subject: "Milestone Email Test"
  end
end
