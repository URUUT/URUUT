class NewslettersController < ApplicationController

  def create
    newsletter = Newsletter.new(params[:newsletter])

    render :json => { :created => newsletter.save }
  end

end
