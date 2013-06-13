class DonationsController < ApplicationController
	before_filter :authenticate_user!
  before_filter :set_session_page, :set_session_wizard
  layout "landing"

	def new
		@donation = Donation.new
    @perk = Perk.find(params[:perk])
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount]
    @perk_description = params[:description]
    @project = Project.find(session[:current_project])
    @perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
    session[:perk_id] = params[:perk]
	end

  def default_perk
    @donation = Donation.new
    @perk = Perk.new
    @perk.id = params[:amount]
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount]
    @perk_description = params[:description]
    @project = Project.find(session[:current_project])
    if params[:amount].blank?
      @perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
    else
      if @project.perk_permission
        perks = @project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
      else
        perks = DEFAULT_PERK
      end
      @perks = []
      perks.each do |perk|
        if perk[1].to_f <= params[:amount].to_f
          @perks.push(perk)
        end
      end
    end
    render :new
  end

  def change_perk
    if !params[:id].eql?("custom")
      if params["amount"].blank?
        @perk = Perk.find(params[:id])
        session[:perk_id] = @perk.id
      else
        @perk = Perk.new
        @perk.id = params["level"]
        @perk.amount = params["amount"]
        project = Project.find(params["project_id"])
        perks = project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
        @perks = []
        perks.each do |perk|
          if perk[1].to_f <= params["amount"].to_f
            @perks.push(perk)
          end
        end
        @perk.name = "LEVEL #{@perk.id}"
        @perk.description = "You will receive #{@perk.amount} Uruut Reward Points when you seed $#{@perk.amount}"
      end
    else
      @perk = Perk.new
      @perk.id = params["level"]
      @perk.amount = params["custom_seed"]
      project = Project.find(params["project_id"])
      perks = project.perks.order(:amount).map{ |perk| [perk.name, perk.amount.to_i] }
      @perks = []
      perks.each do |perk|
        if perk[1].to_f <= params["custom_seed"].to_f
          @perks.push(perk)
        end
      end
      @perk.name = "LEVEL #{@perk.id}"
      @perk.description = "You will receive #{@perk.amount} Uruut Reward Points when you seed $#{@perk.amount}"
    end
  end

	def create
    params[:donation][:perk_name] = params[:perk_name]
    @donation = Donation.new(params[:donation])
    @donation.confirmed = false

    if @donation.save
      session.merge!(:donation_id => @donation.id, :card_token => @donation.token, :card_type => @donation.card_type,
        :card_last4 => @donation.card_last4)
      session[:perk_type] = params[:perk_type]
      session[:payment_amount] = params[:donation][:amount]
      session[:project_id_of_perk_selected] = params[:donation][:project_id]
      redirect_to donation_steps_path
    else
      render :new
    end

    #@donation = Donation.new(params[:donation])
    #@token = @donation.token
    #if @donation.save_with_payment
    #  redirect_to project_url(@donation.project_id), :notice => "Thank you for contributing!"
    #else
    #  render :new
    #end
	end

	def edit
		@donation = Donation.unscoped.find(params[:id])
    @project = @donation.project
		@donation.save!
	end

	def update
		@donation = Donation.unscoped.find(params[:id])
    session[:card_last4] = params[:donation][:card_last4]
    session[:card_type] = params[:donation][:card_type]
    params[:donation][:perk_name] = params[:perk_name]
    current_user.update_attributes(uruut_point: session[:payment_amount])
		if @donation.update_attributes(params[:donation])
			flash[:notice] = "Successfully updated donation."
		end
		redirect_to donation_steps_path
	end

  def more_donators
    @donators = Donation.where(project_id: params[:id])
  end

  private

  def set_session_page
    session[:page_active] = "project"
  end

end
