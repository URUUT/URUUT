class ProjectsController < ApplicationController
	require 'bitly'
  require "net/http"
  require "uri"

  before_filter :authenticate_user!, :only => [:index, :create, :edit, :update]

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
  session[:current_project] = @project.id
  logger.debug("Current session id is: #{session[:current_project]}")
  @project.update_attributes!(params[:project])
  @perks = Perk.where("project_id = ?", @project.id)
  @connected = session[:connected]
  logger.debug(@connected)
end

def show
  @project = Project.find(params[:id])
  @sponsorships = @project.sponsorship_benefits
  @sponsorships.each do |s|
    logger.debug(s.name)
    logger.debug(SponsorshipBenefit.find(s.sponsorship_level_id))
  end
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
      if @project.sponsorship_benefits.blank? || params["#{level}"]["id_#{count}"].nil?
        unless params["#{level}"]["info_#{count}"].blank?
          data <<  {name: params["#{level}"]["info_#{count}"],sponsorship_level_id: key, project_id: @project.id, status: status}
        end
     else
        sponsorship_benefit = SponsorshipBenefit.find(params[level]["id_#{count}"])
        sponsorship_benefit.update_attributes({name: params["#{level}"]["info_#{count}"],sponsorship_level_id: key, project_id: @project.id, status: status})
     end
    end
    data
  end

  SponsorshipBenefit::SPONSORSHIP_BENEFITS.each do |key, value|

    case key
      when 1 then sponsorship_benefits += sponsorship_benefit_level("platinum", value, key)
      when 2 then sponsorship_benefits += sponsorship_benefit_level("gold", value, key)
      when 3 then sponsorship_benefits += sponsorship_benefit_level("silver", value, key)
      when 4 then sponsorship_benefits += sponsorship_benefit_level("bronze", value, key)
    end
    
  end

  @sponsorship_benefits = SponsorshipBenefit.create(sponsorship_benefits)
  @project.update_attributes!(params[:project])
  
  if @project.bitly.blank?
    bitly = Bitly.client
    page_url = bitly.shorten("#{request.scheme}://#{request.host_with_port}/projects/#{@project.id}")
    @project.bitly = page_url.short_url
  end

  if @project.save
    respond_to do |format|
      format.js { render :js => @project.id }
    end
  end
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
  @project = Project.find_by_id(session[:current_project])
  if params[:video_type].eql?("seed")
    @project.seed_video = params[:video_link]
  else
    @project.cultivation_video = params[:video_link]
  end

  @project.save
  respond_to :js
end

def save_image
  @project = Project.find_by_id(session[:current_project])
  if params[:large_image]
   @project.large_image = params[:large_image]
 elsif params[:seed_image]
   @project.seed_image = params[:seed_image]
 elsif params[:cultivation_image]
  @project.cultivation_image = params[:cultivation_image]
end

if @project.save
  render :nothing => true
end
end

def add_perk
  perk = Perk.new
  perk.name = params[:name]
  perk.amount = params[:amount]
  perk.description = params[:description]
  perk.project_id = params[:project]
  if perk.save!
    respond_to do |format|
      format.text { render :text => "Success" }
	#format.js { render :js => perk.id }
end
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
  project.ready_for_approval = 1
  if project.save!
    logger.debug("Saving!!!")
    respond_to do |format|
      Project.send_confirmation_email(project)
      format.text { render :text => "successful" }
    end
  end
end

end
