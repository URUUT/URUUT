class DonationMailer < ActionMailer::Base
  layout 'mailer'
  default from: "exchange@techbridge.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #

  def share_project(recepient, project_id, user_id)
    @project = Project.find(project_id)
    @project_title = @project.project_title
    @project_id = @project.id
    user = User.find_by_id(user_id)
    @donator_name = "#{user.first_name}" + " #{user.last_name}"
    @image = @project.large_image
    @host = ActionMailer::Base.default_url_options[:host]
    @remove_signature = true

    mail to:'exchange@techbridge.org', bcc: recepient, subject: "Check out the project I supported"
  end

  def donation_confirmation(donation)
    user = User.find_by_id(donation.user_id)
    project = Project.find(donation.project_id)
    sponsor = User.find_by_id(project.user_id)

    @donator_name = "#{user.first_name}" + " #{user.last_name}"
    @email = user.email
    @image = project.large_image
    @host = ActionMailer::Base.default_url_options[:host]
    @project = project
    @project_id = project.id
    @project_facebook = @project.facebook_page
    @project_twitter = @project.twitter_handle
    @project_title = project.project_title
    @sponsor_email = sponsor.email
    @sponsor_name = "#{sponsor.first_name}" + " #{sponsor.last_name}"
    @remove_signature = true

    mail to: @email, subject: "Thank You, Donor!"
  end

  def send_donation_report
    attachments['donation_report.csv'] = File.read('reports/donor_report.csv')

    mail to: 'cbartels@uruut.com', subject: 'Donation Report', body: ''
  end

end