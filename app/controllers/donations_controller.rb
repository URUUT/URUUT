class DonationsController < ApplicationController
	
	def new
		@donation = Donation.new
	end

	def create
		@donation = Donation.new(params[:donation])
		@token = @donation.token
	    if @donation.save
	      redirect_to project_url(@donation.project_id), :notice => "Thank you for contributing!"
	    else
	      render :new
	    end
	end

end
