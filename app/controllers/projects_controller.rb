class ProjectsController < ApplicationController
  require 'bitly'
  require "net/http"
  require "uri"

  before_filter :authenticate_user!, :only => [:index, :create, :edit, :update]
  before_filter :set_session_page

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

  def create
    @project = Project.new(params[:project])
    @project.user_id = current_user.id
    if @project.save
      respond_to do |format|
        format.json { render :json => @project.id }
      end
    end
  end

  def edit
    @project = Project.find(params[:id])
    sort_sponsorships = @project.project_sponsors.sort_by {|ps| ps.level_id}
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
    session[:current_project] = @project.id
    logger.debug("Current session id is: #{session[:current_project]}")
    @project.update_attributes!(params[:project])
    @perks = Perk.where("project_id = ?", @project.id)
    logger.debug(@connected)
  end

  def show
    @project = Project.find(params[:id])
    sort_sponsorships = @project.project_sponsors.sort_by {|ps| ps.level_id}
    @project_sponsors = sort_sponsorships.group_by {|sponsor| sponsor.level_id}
    @sponsorship_benefits = @project.sponsorship_benefits.where(status: true).group_by {|sponsor| sponsor.sponsorship_level_id}
    @sponsorship_levels = SponsorshipLevel.all
    @donation = Donation.where("project_id = ?", @project.id)
    @perks = Perk.where("project_id = ?", @project.id)
    @user = User.find(@project.user_id)
    session[:current_project] = @project.id
    render :layout => 'landing'
  end

  def update
    @project = Project.find(params[:id])
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
          if @project.goal.to_i * 0.1 >= 500
            cost = 500
          else
            cost = 0.1 * @project.goal.to_i
          end
        end
        if @project.sponsorship_benefits.blank? || params["#{level}"]["id_#{count}"].nil?
          unless params["#{level}"]["info_#{count}"].blank?
            data <<  {name: params["#{level}"]["info_#{count}"],sponsorship_level_id: key, project_id: @project.id, status: status, cost: cost}
          end
        else
          sponsorship_benefit = SponsorshipBenefit.find(params[level]["id_#{count}"])
          sponsorship_benefit.update_attributes({name: params["#{level}"]["info_#{count}"],sponsorship_level_id: key, project_id: @project.id, status: status, cost: cost})
        end
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

    @sponsorship_benefits = SponsorshipBenefit.create(sponsorship_benefits)
    params[:project][:goal] = params[:project][:goal].gsub(",", "") if !params[:project][:goal].nil?
    params[:project][:sponsor_permission] = params[:project][:sponsorship_permission] if !params[:project][:sponsorship_permission].nil?
    @project.update_attributes!(params[:project])
    if @project.bitly.blank?
      bitly = Bitly.client
      page_url = bitly.shorten("#{request.scheme}://#{request.host_with_port}/projects/#{@project.id}") rescue nil
      @project.bitly = page_url.short_url rescue nil
    end

    if @project.save
      respond_to do |format|
        format.json { render :json => @project.id }
      end
    end
  end

  def skip_sponsor
    session[:step] = "fourth"
    redirect_to :back
    project = Project.find(session[:current_project])
    project.update_attributes(sponsor_permission: false)
  end

  def stripe_update
    code = params[:code]
    client = OAuth2::Client.new(ENV['STRIPE_CLIENT_ID'], ENV['STRIPE_KEY'], :site => "https://connect.stripe.com/oauth/authorize")
    logger.debug(client.to_yaml)
    token = client.auth_code.get_token(code, :headers => {'Authorization' => "Bearer #{ENV['STRIPE_KEY']}"})
    logger.debug(token.params['stripe_publishable_key'])

    project = Project.find(session[:current_project])
    project.publishable_key = token.params['stripe_publishable_key']
    project.project_token = token.token
    project.save!

    logger.debug(project.project_token)
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
    redirect_to "/projects/#{@project.id}/edit#assets"
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

  def add_perk
    session[:step] = params[:step]
    perk_permission = params[:perk_permission].eql?("yes") ? true : false
    Project.update(params[:project], perk_permission: perk_permission)
    unless perk_permission.eql?(false) && params[:name].blank?
      perk = Perk.new
      perk.name = params[:name]
      perk.amount = params[:amount]
      perk.description = params[:description]
      perk.project_id = params[:project]
      perk.perks_available = params[:perks_available]
      perk.limit = params[:limit].eql?("yes") ? true : false
      perk.save!
    end
    respond_to do |format|
      format.text { render :text => "Success" }
    end
  end

  def get_perk
    perk = Perk.find_by_id(params[:id])
    respond_to do |format|
      format.json { render :json => {name: perk.name, amount: perk.amount, description: perk.description, id: perk.id} }
    end
  end

  def update_perk
    perk = Perk.find_by_id(params[:id])
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
    perk = Perk.find_by_id(params[:id])
    if perk.destroy
      respond_to do |format|
        format.json { render :json => {destroy: true} }
      end
    end
  end

  def submit_project
    logger.debug("ID was: #{params[:id]}")
    project = Project.find_by_id(params[:id])
    project.ready_for_approval = 0
    project.live = 1
    project.approval_date = Date.today.strftime("%F")
    if project.save!
      logger.debug("Saving!!!")
      session[:step] = nil
      respond_to do |format|
        # Project.send_confirmation_email(project)
        format.json { render :json => project.ready_for_approval }
      end
    end
  end

  def update_image
    @project = Project.find_by_id(session[:current_project])
    image = params[:status].eql?("seed_image") ? 'seed_image' : 'cultivation_image'
    @project.update_attribute(image.to_sym, params[:image])
    render json: { project_id: @project.id }
  end

  def delete_image
    @project = Project.find(params[:id])
    params[:type].eql?("seed_image") ? @project.seed_image = nil : @project.cultivation_image = nil
    @project.save!

    redirect_to :back
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
    youtube_client = YouTubeIt::Client.new
    video_data = youtube_client.video_by(link)
    video_data.player_url
  end

end
