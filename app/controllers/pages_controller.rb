class PagesController < ApplicationController

  def index
  	@projects = Project.find(:all)
    @ending = Project.find(:all, :order => "duration")
  end

  def discover
  	@cat = params[:category]
    @category = Project.where("live = true and deleted = false and category = '#{@cat}'").page(params[:page]).per(9)
    @projects = Project.where('live = true AND deleted = false').page(params[:page]).per(9)
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

  def how_it_works
    # session[:previous_page] = request.referer
  end
  
  def home
    render :layout => "landing"
  end

end
