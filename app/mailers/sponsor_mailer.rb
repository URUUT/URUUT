class SponsorMailer < ActionMailer::Base
  layout 'mailer'
  helper :mailer
  helper MailerHelper
  include MailerHelper

  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def share_project(recepient, project_id, user_id)
    @project = Project.find(project_id)
    project_sponsor = ProjectSponsor.find_by_id(user_id)
    @sponsor_name = project_sponsor.name
    @image = @project.large_image
    @project_title = @project.project_title
    @project_id = @project.id
    @host = ActionMailer::Base.default_url_options[:host]

    mail to: recepient, subject: "Share from Crowfundproject sponsor"
  end

  def new_sponsor(sponsor)
    project_sponsor = ProjectSponsor.find_by_sponsor_id(sponsor.id)
    benefit_level = SponsorshipLevel.find_by_id(project_sponsor.level_id)
    project = Project.find(project_sponsor.project_id)
    user = User.find_by_id(project.user_id)

    @donator_name = "#{user.first_name}" + " #{user.last_name}"
    @email = user.email
    @image = project.large_image
    @host = ActionMailer::Base.default_url_options[:host]
    @project = project
    @project_id = project.id
    @project_name = project.project_title
    @project_facebook = @project.facebook_page
    @project_twitter = @project.twitter_handle
    @project_title = project.title
    # @sponsor_email = sponsor.email
    @sponsorship_level = benefit_level.name
    @sponsorship_cost = ActionController::Base.helpers.number_to_currency(project_sponsor.cost, precision: 0)

    @name = "#{user.first_name}" + " #{user.last_name}"
    @sponsor_name = project_sponsor.name
    @sponsor_real_name = sponsor.name
    @sponsor_email = sponsor.email

    mail to: @email, subject: "Sponsor thank you follow-up"
  end

  def sponsor_thank_you(sponsor, email)
    project_sponsor = ProjectSponsor.find_by_sponsor_id(sponsor)
    project = Project.find(project_sponsor.project_id)
    user = User.find_by_id(project.user_id)

    @email = email
    @name = project_sponsor.name
    @sponsor_name = "#{user.first_name}" + " #{user.last_name}"
    @image = project.large_image
    @host = ActionMailer::Base.default_url_options[:host]
    @project_name = project.project_title
    @project_sponsor = project.organization
    @project_facebook = project.facebook_page
    @project_twitter = project.twitter_handle
    @project_id = project.id

    mail to: @email, subject: "Thank You, Sponsor!"
  end

end
