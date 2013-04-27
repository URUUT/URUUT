class DonationsController < ApplicationController
	before_filter :authenticate_user!
  layout "landing"

	def new
    logger.debug(session[:current_project])
		@donation = Donation.new
    @perk_name = params[:name].to_s
    @perk_amount = params[:amount]
    @perk_description = params[:description]
    @project = Project.find(session[:current_project])
    logger.debug(@project.title)
	end

	def create
		@donation = Donation.new(params[:donation])
		@token = @donation.token
	    if @donation.save_with_payment
	      redirect_to project_url(@donation.project_id), :notice => "Thank you for contributing!"
	    else
	      render :new
	    end
	end

	def edit
		@donation = Donation.find(params[:id])
		@donation.save!
	end

	def update
		@donation = Donation.find(params[:id])
		if @donation.update_attributes(params[:donation])
			flash[:notice] = "Successfully updated donation."
		end
		redirect_to project_path(@donation.project_id)
	end

end
