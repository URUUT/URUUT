class PagesController < ApplicationController
  layout "application", :except => [:index, :discover, :about, :contact]
  layout "landing", :only => [:index, :discover, :about, :home, :funding_sources,
    :search, :pricing, :choose_plan, :change_plan, :landing, :donor_relationship,
    :donor_convenience, :fundraising, :analytics]
  skip_before_filter :set_previous_page
  before_filter :set_session_page
  before_filter :set_session_wizard, except: :home

  def index
    projects = Project.order_by_percentage
    project_success = Project.order_by_raised
    @projects = Kaminari.paginate_array(projects).page(params[:page]).per(9)
    @project_success = Kaminari.paginate_array(project_success).page(params[:page]).per(6)
  end

  def home
    session[:connected] = params[:code]
    session[:step] = true
  end

  def search
    projects_list
  end

  def search_category_or_location
    projects_list
    respond_to :js
  end

  def discover
  	@cat = params[:category]
    @category = Project.where("live = true AND deleted = false AND category = '#{@cat}'").page(params[:page]).per(9)
    @projects = Project.where('live = true AND deleted = false').page(params[:page]).per(9)
  end

  def download_article
    send_file "#{Rails.root}/public/articles/#{params[:file]}", filename: params[:file], type: 'application/pdf'
  end

  def categories
  	@category = Project.where("category = ?", params[:category])
  end

  def contact
  end

  def choose_plan
    @marketing_info = MarketingInfo.new
  end

  def contact_send
    name = params[:pages][:name]
    email = params[:pages][:email]
    subject = params[:pages][:subject]
    message = params[:pages][:message]

    ContactMailer.delay.contact_confirmation(name, email, subject, message)
    redirect_to contact_pages_url, notice: "Thank You!!! Your Message Has Been Sent"
  end

  def how_it_works
    # session[:previous_page] = request.referer
  end

  def extreme_makeover
    @demo = Demo.new
    render layout: false
  end

  def media
    @press_releases = PressRelease.all
    @press_coverages = PressCoverage.order("release_date DESC").all
  end

  private
  def projects_list
    query = []

    fields = %w{
      title description location duration goal category address city state
      zip neighborhood short_description website facebook_page twitter_handle
      organization story about project_title organization_type
      organization_classification
    }

    fields.each do |field|
      query << "#{field} ILIKE :keyword"
    end

    @projects = Project.live.where("#{query.join(' OR ')}", :keyword => "%#{params[:keyword]}%")
                        .by_city(params[:city])
                        .by_category(params[:category])
                        .reject { |project| project.status == "Funding Completed" || project.status == nil }

    @project_success = Project.live.where("#{query.join(' OR ')}", :keyword => "%#{params[:keyword]}%")
                        .by_city(params[:city])
                        .by_category(params[:category])
                        .reject { |project| project.status == "Funding Active" || project.status == nil }
  end

  private

  def set_session_page
    session[:page_active] = if action_name.eql?("about")
      "about"
    else
      action_name.eql?("home") ? "home" : "project"
   end
 end

end
