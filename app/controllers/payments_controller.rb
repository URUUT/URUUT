class PaymentsController < ApplicationController

  def purchase
    project = Project.find(params[:project_id])
    sponsor = Sponsor.find(params[:sponsor_id])
    project_sponsor = project.project_sponsors.find_by_sponsor_id(sponsor.id)

    credit_card = ActiveMerchant::Billing::CreditCard.new(
      :type               => "visa",
      :number             => sponsor.card_number,
      :verification_value => sponsor.cvc,
      :month              => sponsor.month,
      :year               => sponsor.year_card,
      :first_name         => sponsor.name.split(" ")[0],
      :last_name          => sponsor.name.split(" ")[1]
      )

    if credit_card.valid?
    # or gateway.purchase to do both authorize and capture
      response = GATEWAY.authorize(project_sponsor.cost, credit_card, :ip => request.remote_ip)
      if response.success?
        GATEWAY.capture(project_sponsor.cost, response.authorization)
        redirect_to project_url(project.id), notice: "Thanks, you successfully registered as a sponsor in project #{project.project_title}"
      else
        redirect_to :back, alert: "Sorry your creditcard is expired."
      end
    else
      redirect_to :back, alert: "Sorry your creditcard is expired."
    end
  end

end