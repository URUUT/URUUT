class PaymentsController < ApplicationController

  def purchase
    project = Project.find(params[:project_id])
    sponsor = Sponsor.find(params[:sponsor_id])
    project_sponsor = project.project_sponsors.find_by_sponsor_id(sponsor.id)
    card_token = project_sponsor.card_token
    amount = (project_sponsor.cost * 100).to_i
    fee = (amount * 0.06).to_f
    access_token = project.project_token
    
    Stripe.api_key = ENV['STRIPE_KEY']
    
    begin
      charge = Stripe::Charge.create({
        :amount => amount, # amount in cents, again
        :currency => "usd",
        :card => card_token,
        :description => project_sponsor.name,
        :application_fee => fee
      },
      access_token)
    rescue Stripe::CardError => e
      # The card has been declined
    end
    render :nothing => 'true'
    
  end

end