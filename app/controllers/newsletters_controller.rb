class NewslettersController < ApplicationController

  def create
    newsletter = Newsletter.new(params[:newsletter])

    if result = newsletter.save
      NewsletterMailer.newsletter_confirmation(newsletter).deliver
    end

    render :json => { :created => result }
  end

end
