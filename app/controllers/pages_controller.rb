class PagesController < ApplicationController
  layout "application", :except => [:index, :discover, :about, :contact]
  layout "landing", :only => [:index, :discover, :about, :home, :funding_sources]
  skip_before_filter :set_previous_page

  def index
    @projects = Project.where(["city ILIKE (:q) OR category ILIKE (:q)", {q: "%#{params[:keyword]}%"}]).by_city(params[:city]).by_category(params[:category]).page(params[:page])
    # if params[:keyword]
    #   @projects = Project.by_keyword(params[:keyword]).page(params[:page]).per(1)
    #   #@projects = Project.where("title LIKE :keyword OR description LIKE :keyword", :keyword => "%#{params[:keyword]}%").page(params[:page]).per(1)
    # else
    #   @projects = Project.where("live = 1 AND ready_for_approval = 0").by_city(params[:city]).
    #       by_category(params[:category]).all
    #   @ending = Project.where("live = 1 AND ready_for_approval = 0").by_city(params[:city]).
    #       by_category(params[:category]).order(:duration).all
    # end
    logger.debug(@projects)
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
  end

  def contact_send
    name = params[:pages][:name]
    email = params[:pages][:email]
    subject = params[:pages][:subject]
    message = params[:pages][:message]

    logger.debug(params[:pages][:subject])

    ContactMailer.contact_confirmation(name, email, subject, message).deliver
    flash[:notice] = 'Thank You!!! Your Message Has Been Sent'
    redirect_to contact_pages_url
  end

  def how_it_works
    # session[:previous_page] = request.referer
  end

end
