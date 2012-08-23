class DonationsController < ApplicationController
	
	def new
		@donation = Donation.new
	end

	def create
		@donation = Donation.new(params[:donation])
		@token = @donation.token
	    if @donation.save
	      redirect_to root_path, :notice => "Thank you for subscribing!"
	    else
	      render :new
	    end
	end

end
