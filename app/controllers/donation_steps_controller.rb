class DonationStepsController < ApplicationController
  include Wicked::Wizard
  steps :confirmation, :thank_you

  def show
    if session[:donation_id]
      @donation = Donation.unscoped.find(session[:donation_id])
      @project = @donation.project
      @card_type = session[:card_type]
      @card_last4 = session[:card_last4]
      @perk = Perk.find(session[:perk_id])
      @need_doctype = true
      render_wizard
    else
      redirect_to root_path
    end

    session.except!(:donation_id, :card_token, :perk_id) if step == :thank_you
  end

  def update
    @donation = Donation.unscoped.find(session[:donation_id])
    @donation.token = session[:card_token]

    if @donation.save_with_payment
      redirect_to wizard_path(:thank_you)
    else
      redirect_to wizard_path(:confirmation)
    end
  end

end
