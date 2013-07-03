class DonationMailer < ActionMailer::Base
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def donation_confirmation(donation)
    user = User.find_by_id(donation.user_id)
    project = Project.find(donation.project_id)
    sponsor = User.find_by_id(project.user_id)
    
    @donator_name = "#{user.first_name}" + " #{user.last_name}"
    @email = user.email
    @image = project.large_image
    @host = ActionMailer::Base.default_url_options[:host]
    @project = project
    @project_facebook = @project.facebook_page
    @project_twitter = @project.twitter_handle
    @project_title = project.title
    @sponsor_email = sponsor.email
    @sponsor_name = "#{sponsor.first_name}" + " #{sponsor.last_name}"

    mail to: @email, subject: "Donor Thank You"
  end
end