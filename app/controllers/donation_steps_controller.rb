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
        @perk.get_perk_name(session[:payment_amount])

        if session[:payment_amount].to_s.split(".")[1].eql?("0")
          @perk.description = "You will receive #{session[:payment_amount].to_i} Uruut Reward Points when you seed $#{session[:payment_amount].to_i}"
        else
          @perk.description = "You will receive #{session[:payment_amount].to_i} Uruut Reward Points when you seed $#{session[:payment_amount].to_f}"
        end
      else
        @perk = Perk.new
        @perk.name = @donation.perk_name
        @perk.amount = @donation.amount
        if @perk.amount.to_s.split(".")[1].eql?("0")
          @perk.description = "You will receive #{@perk.amount.to_i} Uruut Reward Points when you seed $#{@perk.amount.to_i}"
        else
          @perk.description = "You will receive #{@perk.amount.to_i} Uruut Reward Points when you seed $#{@perk.amount.to_f}"
        end
      end

      session[:donation_thank_you] = {
        amount: @donation.amount,
        project_id: @project.id,
        project_large_image: @project.large_image,
        project_bitly: @project.bitly,
        project_title: @project.project_title,
        project_category: @project.category,
        perk_name: @perk.name,
        perk_description: @perk.description
      }

      render_wizard
    else
      redirect_to root_path
    end
    session.except!(:donation_id, :card_token, :perk_id) if step == :thank_you
  end

  def update
    @donation = Donation.unscoped.find(session[:donation_id])
    @donation.token = session[:card_token]
    if @donation.save_with_payment && @donation.create_charges!
      donate_badge = Merit::Badge.new(id:3, name:"Project donation badge")
      if !current_user.badges.include?(donate_badge)
        current_user.add_badge(3)
      end
      perk = Perk.where(project_id: session[:project_id_of_perk_selected], amount: session[:payment_amount]).first
      if !perk.nil? && perk.limit? && perk.perks_available.to_i > 0
        new_perk_available = perk.perks_available.to_i - 1
        perk.update_attributes!(perks_available: new_perk_available)
      end
      current_user.update_attributes!(uruut_point: current_user.uruut_point.to_i + session[:payment_amount].to_i)
      session.delete(:perk_amount)
      Donation.send_confirmation_email(@donation)
      redirect_to wizard_path(:thank_you)
    else
      # redirect_to wizard_path(:confirmation)
      new_donation_path( perk: session[:perk_id], amount: session[:perk_amount], name: session[:donation_thank_you][:perk_name], project_id: session[:project_id_of_perk_selected] )
    end
  end

  private

  def set_session_page
    session[:page_active] = "project"
  end

end
