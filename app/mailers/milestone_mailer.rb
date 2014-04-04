class MilestoneMailer < ActionMailer::Base
  layout 'mailer'
  default from: "exchange@techbridge.org"

  def milestone_email(email, percent, project)
  	  @email = email
  	  @percent = percent
  	  @project = Project.find_by_id(project)
  	  @image = @project.large_image
      @host = ActionMailer::Base.default_url_options[:host]
  	  mail to: @email, subject: "Milestone Email Test"
  end
end
