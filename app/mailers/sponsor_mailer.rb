class SponsorMailer < ActionMailer::Base
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def share_project(recepient, project_id)
    @project = Project.find(project_id)
    mail to: recepient, subject: "Share from Crowfundproject sponsor"
  end

end
