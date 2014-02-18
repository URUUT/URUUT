class DonationMailerPreview
  def share_project
    DonationMailer.share_project recepient, project_id, user_id
  end


  def donation_confirmation
    DonationMailer.donation_confirmation donation
  end


  def send_donation_report
    DonationMailer.send_donation_report 
  end

end
