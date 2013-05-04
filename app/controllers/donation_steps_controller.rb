class DonationStepsController < ApplicationController
  include Wicked::Wizard
  steps :confirmation, :thank_you

  def show
    if session[:donation_id]
      @donation = Donation.find(session[:donation_id])
      render_wizard
    else
      redirect_to root_path
    end

    if step == :thank_you
      session.delete(:donation_id)
      session.delete(:card_token)
    end
  end

  def update
    @donation = Donation.find(session[:donation_id])
    @donation.token = session[:card_token]

    if @donation.save_with_payment
      redirect_to wizard_path(:thank_you)
    else
      redirect_to wizard_path(:confirmation)
    end
    #render_wizard @donation
  end

end
