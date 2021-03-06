class PaymentsController < ApplicationController

  def purchase
    project = Project.find(params[:project_id])
    sponsor = Sponsor.find(params[:sponsor_id])
    project_sponsor = project.project_sponsors.unscoped.find_by_sponsor_id(sponsor.id)
    project_sponsor.update_attributes!(confirmed: true)

    SponsorMailer.delay.new_sponsor(sponsor)
    SponsorMailer.delay.sponsor_thank_you(sponsor.id, sponsor.email)

    redirect_to thank_you_for_sponsor_url(project.id, sponsor.id)

  end

end
