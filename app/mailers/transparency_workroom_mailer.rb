class TransparencyWorkroomMailer < ActionMailer::Base
  layout 'mailer'
  default from: "info@uruut.com"

  def transparency_workroom_update(user, project)
    @user = user
    @manager = User.find_by_id(project.user_id)
    @project = project
    mail to: user.email, subject: 'Transparency Workroom Update'
  end
end
