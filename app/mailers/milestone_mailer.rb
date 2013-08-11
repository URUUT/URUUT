class MilestoneMailer < ActionMailer::Base
  default from: "info@uruut.com"
  
  def milestone_email(email, percent, project)
  	  mail to: email, subject: test
  end
end
