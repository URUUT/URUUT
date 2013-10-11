class ProjectsController < ApplicationController
  require 'bitly'
  require "net/http"
  require "uri"

  skip_before_filter :verify_authenticity_token, only: :add_perk
  before_filter :session_path, only: :create
  before_filter :authenticate_user!, :only => [:index, :create, :edit, :update]
  before_filter :set_session_page
  before_filter :set_session_wizard, only: [:new, :create]
  before_filter :admin_required!, only: [:edit, :update, :delete_image]

  layout false, :only => "stripe_update"

  def index
    @projects = Project.find_all_by_user_id(current_user.id)
  end

  def new
    @project = Project.new
    session[:current_project] = ''
    session[:connected] = ''


    #    @project.perks.build
    #    @project.galleries.build
    render :layout => 'landing'
  end

  def download_stripe_guide
    send_file "#{Rails.root}/public/data/Uruut_StripeQuickStartGuide.pdf", :type=>"application/pdf", :x_sendfile=>true
  end

  def download
    send_file "#{Rails.root}/public/data/URUUT_ProjectCreationWizard_Step1.psd", :type=>"application/psd", :x_sendfile=>true
  end

  def create
    @project = Project.new(params[:project])
    @project.live = 0
    @project.user_id = current_user.id
    @project.perk_permission = false

    respond_to do |format|
      if @project.save
        format.json { render :json => @project.id }
      else
        format.json { render :json => "error" }
      end
    end
  end

  def edit
    sort_sponsorships = @project.project_sponsors.sort_by {|ps| ps.level_id}
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).order(:id).group_by {|sponsor| sponsor.sponsorship_level_id}
    session[:current_project] = @project.id
    @project.update_attributes!(params[:project])
    @perks = @project.perks.order(:amount)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @project = Project.find(params[:id])
    @images = @project.galleries.page(params[:page]).per(6)
    sort_sponsorships = @project.project_sponsors.sort_by {|ps| ps.level_id}
    @project_sponsors = sort_sponsorships.group_by {|sponsor| sponsor.level_id}
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).order(:id).group_by {|sponsor| sponsor.sponsorship_level_id}
    @perks = @project.perks.order(:amount)
    session[:current_project] = @project.id
    render :layout => 'landing'
  end

  def show_more_image
    @project = Project.find(params[:id])
    @images = @project.galleries.page(params[:page]).per(6)
  end

  def update
    sponsorship_benefits = []
    def sponsorship_benefit_level(level, benefit, key)
      data = []
      1.upto(params["#{level}_count"].to_i) do |x|
        count = if !benefit[x - 1].blank?
          !benefit[x - 1][:id].blank? ? benefit[x - 1][:id] : x
        else
          x
        end
        status = params["#{level}"]["#{count}"] ? 1 : 0
        if level.eql?("platinum")
          cost = 0.3 * @project.goal.to_i
        elsif level.eql?("gold")
          cost = 0.1 * @project.goal.to_i
        elsif level.eql?("silver")
          cost = 0.04 * @project.goal.to_i
        else
          if @project.goal.to_i * 0.02 >= 500
            cost = 500
          else
            cost = 0.02 * @project.goal.to_i
          end
        end
        # if @project.sponsorship_benefits.blank? || params["#{level}"]["id_#{count}"].nil?
          unless params["#{level}"]["info_#{count}"].blank?
            data <<  {name: params["#{level}"]["info_#{count}"],sponsorship_level_id: key, project_id: @project.id, status: status, cost: cost}
          end
        # else
        #   sponsorship_benefit = SponsorshipBenefit.find(params[level]["id_#{count}"])
        #   sponsorship_benefit.update_attributes({name: params["#{level}"]["info_#{count}"],sponsorship_level_id: key, project_id: @project.id, status: status, cost: cost})
        # end
      end
      data
    end

    SponsorshipBenefit::SPONSORSHIP_BENEFITS.each do |key, value|

      case key
        when 1 then sponsorship_benefits += sponsorship_benefit_level("platinum", value, key)
        when 2 then sponsorship_benefits += sponsorship_benefit_level("gold", value, key)
        when 3 then sponsorship_benefits += sponsorship_benefit_level("silver", value, key)
        when 4 then sponsorship_benefits += sponsorship_benefit_level("custom", value, key) if params[:custom].present?
      end

    end

    unless params[:project][:duration].blank?
      params[:project][:campaign_deadline] = params[:project][:duration].to_i.days.from_now.to_time
    end

    session[:step] = params[:step]

    if session[:step].eql?("first")
      @project.step = "/projects/#{@project.id}/edit#project-details"
    elsif session[:step].eql?("second")
      @project.step = "/projects/#{@project.id}/edit#perks"
    elsif session[:step].eql?("third")
      @project.step = "/projects/#{@project.id}/edit#sponsorship"
    else session[:step].eql?("fourth")
      @project.step = "/projects/#{@project.id}/edit#assets"
    end

    unless sponsorship_benefits.blank?
      SponsorshipBenefit.where(project_id: params[:id]).destroy_all
      @sponsorship_benefits = SponsorshipBenefit.create(sponsorship_benefits)
    end
    params[:project][:goal] = params[:project][:goal].gsub(",", "") if !params[:project][:goal].nil?
    params[:project][:sponsor_permission] = params[:project][:sponsorship_permission] if !params[:project][:sponsorship_permission].nil?
    @project.update_attributes!(params[:project])
    unless @project.bitly?
      bitly = Bitly.client
      page_url = bitly.shorten("#{request.scheme}://#{request.host_with_port}/projects/#{@project.id}") rescue nil
      @project.bitly = page_url.short_url rescue nil
    end

    if @project.save
      if params[:step].eql?("fourth")
        @perks = @project.perks.order(:amount)
        @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
        respond_to do |format|
          format.js { render action: "skip_sponsor.js.erb" }
        end
      else
        respond_to do |format|
          format.json { render :json => @project.id }
        end
      end
    end
  end

  def update_sponsor_info
    case params[:type]
    when "state"
      Project.update(params[:id].to_i, state: params[:data_value])
    when "organized_type"
      Project.update(params[:id].to_i, organization_type: params[:data_value])
    else
      Project.update(params[:id].to_i, organization_classification: params[:data_value])
    end

    respond_to do |format|
      format.text { render :text => "Success" }
    end
  end

  def set_perk_to_false
    session[:step] = "third"
    Project.update(params[:id], perk_permission: false)
    render nothing: true
  end

  def skip_sponsor
    session[:step] = "fourth"
    @project = Project.find(session[:current_project])
    @project.update_attributes(sponsor_permission: false)
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
    @perks = @project.perks.order(:amount)

    respond_to :js
  end

  def stripe_update
    code = params[:code]
    client = OAuth2::Client.new("#{Settings.stripe.client_id}", "#{Settings.stripe.api_key}", :site => "https://connect.stripe.com/oauth/authorize?scope=read_write")
    token = client.auth_code.get_token(code, :params => {:scope => 'read_write'}, :headers => {'Authorization' => "Bearer #{Settings.stripe.api_key}"})

    project = Project.find(session[:current_project])
    project.publishable_key = token.params['stripe_publishable_key']
    project.project_token = token.token
    project.save!

    if project.project_token
      session[:connected] = "true"
    else
      session[:connected] = ""
    end
    redirect_to "/projects/#{project.id}/edit#sponsor-info"
  end

  def save_video
    link_video = generate_video_link(params[:video_link])

    @project = Project.find_by_id(session[:current_project])
    if params[:video_type].eql?("seed")
      @project.seed_video = link_video
      @project.seed_mime_type = "video"
    else
      @project.cultivation_video = link_video
      @project.cultivation_mime_type = "video"
    end

    @project.save
  end

  def save_image
    @project = Project.find_by_id(session[:current_project])
    if params[:large_image]
      @project.large_image = params[:large_image]
    elsif params[:seed_image]
      @project.seed_image = params[:seed_image]
      @project.seed_mime_type = "image"
    else
      @project.cultivation_image = params[:cultivation_image]
      @project.cultivation_mime_type = "image"
    end

    render :nothing => true if @project.save
  end

  def get_complete_project
    @user = User.find(params[:user_id])
    comparison = params[:status].eql?("Funding Active") ? ">" : "<"
    @projects_created = @user.projects.where("campaign_deadline #{comparison} ? AND live = 1", Time.now).order("updated_at DESC").page(params[:created_page]).per(2)
  end

  def get_complete_project_public
    @user = User.find(params[:user_id])
    comparison = params[:status].eql?("Funding Active") ? ">" : "<"
    @projects_created = @user.projects.where("campaign_deadline #{comparison} ? AND live = 1", Time.now).order("updated_at DESC").page(params[:created_page]).per(2)
  end

  def add_perk
    session[:step] = params[:step]
    perk_permission = params[:perk_permission].eql?("yes") ? true : false
    Project.update(params[:project], perk_permission: perk_permission)
    unless perk_permission.eql?(false) && params[:name].blank?
      limit_status = params[:limit].eql?("yes") ? true : false
      perk = Perk.create(name: params[:name], amount: params[:amount],
                  description: params[:description], project_id: params[:project],
                  perks_available: params[:perks_available], limit: limit_status, perk_limit: params[:perks_available])
    end
    respond_to do |format|

      format.json { render :json => perk.id }
    end
  end

  def get_perk
    perk = Perk.find_by_id(params[:id])
    respond_to do |format|
      format.json { render :json => {name: perk.name, amount: perk.amount, description: perk.description, id: perk.id} }
    end
  end

  def update_perk
    perk = Perk.find(params[:id])
    perk.name = params[:name]
    perk.amount = params[:amount]
    perk.description = params[:description]
    if perk.save!
      respond_to do |format|
        format.json { render :json => perk }
      end
    end
  end

  def delete_perk
    if Perk.find(params[:id]).destroy
      respond_to do |format|
        format.json { render :json => {destroy: true} }
      end
    end
  end

  def submit_project
    project = Project.find_by_id(params[:id])
    # project_live = 0
    project.live = 0
    # project.approval_date = Date.today.strftime("%F")
    project.ready_for_approval = 1
    if project.save!
      session[:step] = nil
      respond_to do |format|
        Project.delay.send_confirmation_email(project)
        format.json { render :json => project.ready_for_approval }
      end
    end
  end

  def update_image
    @project = Project.find_by_id(session[:current_project])
    if params[:status].eql?("seed_image")
      @project.update_attributes(seed_mime_type: "image", seed_image: params[:image])
    else
      @project.update_attributes(cultivation_mime_type: "image", cultivation_image: params[:image])
    end

    render nothing: true
  end

  def delete_image
    params[:type].eql?("seed_image") ? @project.seed_image = nil : @project.cultivation_image = nil
    @project.save!
    render nothing: true
  end

  def destroy
    Project.find(params[:id]).destroy
    redirect_to current_user
  end

  def update_content_assets_tab
    @project = Project.find(params[:id])
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
    @perks = @project.perks.order(:amount)

    respond_to do |format|
      format.js { render action: "skip_sponsor.js.erb" }
    end
  end

  def update_sponsorship_content
    respond_to :js
  end

  def update_td_mark
    @project = Project.find(params[:id])
    respond_to :js
  end

  def set_previous_path_for_registration
    session[:path] = params[:url]
    redirect_to new_user_registration_url
  end

  def set_previous_path_for_registration_perk
    session[:path] = URI.escape(CGI::unescape params[:url])
    redirect_to new_user_registration_url
  end

  private

  def set_session_page
    session[:page_active] = if action_name.eql?("edit") or action_name.eql?("new")
      "funding"
      else
      "project"
      end
  end

  def generate_video_link(link)
    video_data = video_data_by_link(link)
    video_data.player_url.gsub('&feature=youtube_gdata_player', '')
  end

  def session_path
    session[:path] = "project_new"
  end

  def admin_required!
    @project = Project.find(params[:id])
     unless current_user.is_admin?
      unless @project.user.id.eql?(current_user.id)
       flash[:error] = "Sorry, you don't have right permision to accessing page."
       redirect_to root_url and return false
      end
     end
  end

end
