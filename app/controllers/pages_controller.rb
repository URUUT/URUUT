class PagesController < ApplicationController
  layout "landing", :except => [:discover, :contact, :contact_send, :how_it_works]
  skip_before_filter :set_previous_page

  def index
    if params[:keyword]
      @projects = Project.where("title LIKE ?", "%#{params[:keyword]}%").page(params[:page]).per(1)
    else
      @projects = Project.where("live = 1 AND ready_for_approval = 0").by_city(params[:city]).
          by_category(params[:category]).all
      @ending = Project.by_city(params[:city]).by_category(params[:category]).order(:duration).all
    end
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

  def home
    render :layout => "landing"
  end

  def about
    render :layout => "landing"
  end

end
