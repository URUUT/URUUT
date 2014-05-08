require 'open-uri'

class DonationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :default_perk
	before_filter :authenticate_user!
  before_filter :set_session_page, :set_session_wizard, :set_previous_path_for_registration
  layout "landing"

  def new
    @donation = Donation.new
    @perk = Perk.find(params[:perk])
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount].gsub(",", "").to_f
    @perk_description = params[:description]
    @project = Project.find(params[:project_id])
    @perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
    session[:perk_id] = params[:perk]
  end

  def default_perk
    @donation = Donation.new
    @perk = Perk.new
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount].gsub(",", "").to_f
    @perk_description = params[:description]
    @project = Project.find(params[:project_id])
    if params[:amount].blank?
      @perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
      session[:perk_id] = "custom_donate"
    else
      perks = Donation.set_perks(@project)
      @perks = Donation.reorder_perks(perks, @perk_amount)
      @perk_name_selected, @perk_description = Donation.get_perk_info(@project, @perk_amount, @perks)
      session[:perk_id] = Donation.set_perk_id(@perks, @project)
    end
    render :new
  end

  def change_perk
    if !params[:id].eql?("custom")
      if params["amount"].blank?
        @perk = Perk.find(params[:id])
        @project = Project.find(params["project_id"])
        session[:perk_id] = @perk.id
        session[:perk_amount] = @perk.amount.to_f
        @perk_description = @perk.description
      else
        @perk = Perk.new
        @perk.id = params["level"]
        @perk.amount = params["amount"].gsub(",", "").to_f
        session[:perk_amount] = @perk.amount.to_f
        @project = Project.find(params["project_id"])

        perks = Donation.set_perks(@project)
        @perks = Donation.reorder_perks(perks, @perk.amount)
        @perk_name_selected = @perks.last[0]
        @perk_description = @perks.last[3]
        if @project.perk_permission
          session[:perk_id] = @perks.last[2]
        else
          session[:perk_id] = @perks.last[0]
        end
        @perk.name = "Level #{@perk.id}"
        @perk.description = "You will receive #{@perk.amount.to_i} Uruut Reward Points when you seed $#{@perk.amount.to_i}"
      end
    else
      @perk = Perk.new
      @perk.id = params["level"]
      @perk.amount = params["custom_seed"].gsub(",", "")
      @project = Project.find(params["project_id"])

      perks = Donation.set_perks(@project)

      @perks = Donation.reorder_perks(perks, @perk.amount)

      @perk_name_selected, @perk_description = Donation.get_perk_info(@project, @perk.amount, @perks)

      session[:perk_id] = Donation.set_perk_id(@perks, @project)
      session[:perk_amount] = @perk.amount.to_f
      @perk.name = "Custom"
      @perk.description = "You will receive #{@perk.amount} Uruut Reward Points when you seed $#{@perk.amount}"
    end
  end

  def create
    if params[:perk_type].eql?("default")
      params[:donation][:description] = "#{params[:donation][:amount].to_i} Uruut Reward Points"
    else
      params[:donation][:description] = params[:perk_description]
    end
    params[:donation][:perk_name] = params[:name_of_perk]
    logger.debug params[:donation].to_yaml
    @donation = Donation.new(params[:donation])
    @donation.confirmed = false

    if @donation.save
      session.merge!(:donation_id => @donation.id, :card_token => @donation.token, :card_type => @donation.card_type,
                     :card_last4 => @donation.card_last4)
      session[:perk_type] = params[:perk_type]
      session[:payment_amount] = params[:donation][:amount]
      session[:project_id_of_perk_selected] = params[:donation][:project_id]
      session[:perk_amount] = params[:donation][:amount]
      redirect_to donation_steps_path
    else
      render :new
    end

  end

  def edit
    @donation = Donation.unscoped.find(params[:id])
    @project = @donation.project
    perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i, perk.id] }
    @perks = []
    perks.each do |perk|
      if perk[1].to_f <= @donation.amount.to_f
        @perks.push(perk)
      end
    end
    @perk_name_selected = @donation.perk_name
    @donation.save!
  end

  def set_new_perk
    perk = Perk.where(name: params[:perk_name], project_id: params[:project_id]).first
    @perk_name_selected = perk.name
    @perk_description = perk.description
    if perk.nil?
      session[:perk_id] = params[:name_of_perk]
    else
      session[:perk_id] = perk.id
    end
    respond_to :js
  end

  def update
    @donation = Donation.unscoped.find(params[:id])
    session[:card_last4] = params[:donation][:card_last4]
    session[:card_type] = params[:donation][:card_type]
    params[:donation][:perk_name] = params[:name_of_perk]
    params[:donation][:amount] = session[:perk_amount]
    params[:donation][:description] = params[:perk_description]
    session[:payment_amount] = params[:donation][:amount]
    current_user.update_attributes!(uruut_point: session[:payment_amount])
    if params[:donation][:amount].is_a?(String)
      params[:donation][:amount] = params[:donation][:amount].gsub('$', '').gsub(',', '').to_f
    end
    if @donation.update_attributes(params[:donation])
     flash[:notice] = "Successfully updated donation."
   end
   redirect_to donation_steps_path
  end

  def more_donators
    @project = Project.find(params[:id])
    respond_to do |format|
      format.html { redirect_to project_url(@project), notice: "successfully" }
      format.js
    end
  end

  def thank_you
    @need_doctype = true
    @thanks_url = URI.encode(session[:donation_thank_you][:project_bitly])
    render :layout => "application"
  end

  def share_email
    DonationMailer.share_project(params[:emails], params[:project_id], params[:user_id]).deliver
    respond_to :js
  end

  private

  def set_session_page
    session[:page_active] = "project"
  end

  def set_previous_path_for_registration
    session[:path] = params[:url]
  end

end
