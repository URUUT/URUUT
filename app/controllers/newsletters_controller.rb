class NewslettersController < ApplicationController

  def create
    render :json => { :created => true }
  end

end
