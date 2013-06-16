class DonationStepsController < ApplicationController
  include Wicked::Wizard
  steps :confirmation, :thank_you
  before_filter :set_session_page

  def show
    if session[:donation_id]
      @donation = Donation.unscoped.find(session[:donation_id])
      @project = @donation.project
      @card_type = session[:card_type]
      @card_last4 = session[:card_last4]
      @need_doctype = true

      if session[:perk_type].eql?("default")
        @perk = Perk.new
        case session[:payment_amount]
        when "10"
          @perk.name = "Level 1"
        when "25"
          @perk.name = "Level 2"
        when "50"
          @perk.name = "Level 3"
        when "100"
          @perk.name = "Level 4"
        else
          @perk.name = "Level 5"
        end

        @perk.description = "You will receive #{session[:payment_amount]} Uruut Reward Points when you seed $#{session[:payment_amount]}"
      else
        @perk = Perk.new
        @perk.name = @donation.perk_name
        @perk.amount = @donation.amount
        @perk.description = "You will receive #{@perk.amount.to_i} Uruut Reward Points when you seed #{@perk.amount.to_i}"
        # @perk = Perk.where(id: session[:perk_id])
        # if @perk.empty?
        #   @perk = Perk.new
        #   @perk.name = "Custom"
        #   @perk.amount = session[:payment_amount]
        # else
        #   @perk = @perk.first
        # end
      end
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
      perk = Perk.where(project_id: session[:project_id_of_perk_selected], amount: session[:payment_amount]).first
      unless perk.nil?
        new_perk_available = perk.perks_available.to_i - 1
        perk.update_attributes(perks_available: new_perk_available)
      end
      current_user.update_attributes(uruut_point: current_user.uruut_point.to_i + session[:payment_amount].to_i)
      redirect_to wizard_path(:thank_you)
    else
      redirect_to wizard_path(:confirmation)
    end
  end

  private

  def set_session_page
    session[:page_active] = "project"
  end

end
