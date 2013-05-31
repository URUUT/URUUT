class DonationsController < ApplicationController
	before_filter :authenticate_user!
  layout "landing"

	def new
		@donation = Donation.new
    @perk = Perk.find(params[:perk])
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount]
    @perk_description = params[:description]
    @project = Project.find(session[:current_project])
    session[:perk_id] = params[:perk]
	end

  def default_perk
    @donation = Donation.new
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount]
    @perk_description = params[:description]
    @project = Project.find(session[:current_project])

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
        @perk.description = "You will receive #{@perk.amount} Uruut Reward Points when you seed $#{@perk.amount}"
      end
    end
  end

	def create
    @donation = Donation.new(params[:donation])

    if @donation.save
      session.merge!(:donation_id => @donation.id, :card_token => @donation.token, :card_type => @donation.card_type,
        :card_last4 => @donation.card_last4)
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
		@donation.save!
	end

	def update
		@donation = Donation.unscoped.find(params[:id])
		if @donation.update_attributes(params[:donation])
			flash[:notice] = "Successfully updated donation."
		end
		redirect_to project_path(@donation.project_id)
	end

end
