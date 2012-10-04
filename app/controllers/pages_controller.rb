class PagesController < ApplicationController

  def index
  	@projects = Project.find(:all)
  end

  def discover
  	@projects = Project.find(:all)
  	@category = Project.where("category = ?", params[:category])
  end

  def categories
  	@category = Project.where("category = ?", params[:category])
  end

  def contact
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    ContactMailer.contact_confirmation(@name, @email, @message).deliver
  end

end
