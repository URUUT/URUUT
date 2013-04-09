class ProjectConfirmation < ActionMailer::Base
  default from: "info@uruut.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_confirmation.subject
  #
  def project_confirmation(project)
    user = User.find_by_id(project.user_id)
    logger.debug(user)
    
    @name = user.name
    @email = user.email
    @project_title = project.title

    mail to: @email, subject: @project_title
  end
end
