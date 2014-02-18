class MilestoneMailerPreview
  def milestone_email
    MilestoneMailer.milestone_email email, percent, project
  end

end
