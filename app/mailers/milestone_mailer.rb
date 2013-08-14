class MilestoneMailer < ActionMailer::Base
  default from: "info@uruut.com"
  
  def milestone_email(email, percent, project)
  	  @email = email
  	  @percent = percent
  	  @project = Project.find_by_id(project)
  	  @image = @project.large_image
  	  
  	  mail to: @email, subject: "Milestone Email Test"
  end
end
