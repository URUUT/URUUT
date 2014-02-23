class SponsorMailerPreview
  def share_project
    SponsorMailer.share_project recepient, project_id, user_id
  end


  def new_sponsor
    SponsorMailer.new_sponsor sponsor
  end


  def sponsor_thank_you
    SponsorMailer.sponsor_thank_you sponsor, email
  end


  def send_sponsor_report
    SponsorMailer.send_sponsor_report 
  end

end
