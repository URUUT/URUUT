class ProjectsController < ApplicationController
	require 'bitly'
  require "net/http"
  require "uri"

  before_filter :authenticate_user!, :only => [:index, :new, :create, :edit, :update]

  layout false, :only => "stripe_update"

	def index
		@projects = Project.find_all_by_user_id(current_sponsor.id)
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
        format.js { render :js => @project.id }
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
    @donation = Donation.where("project_id = ?", @project.id)
		@perks = Perk.where("project_id = ?", @project.id)
    @user = User.find(@project.user_id)
    session[:current_project] = @project.id
    render :layout => 'landing'
	end

	# def update
#     redirect_to project_steps_path
		# @project = Project.find(params[:id])
#     if @project.update_attributes(params[:project])
#       flash[:notice] = "Successfully updated project."
#       redirect_to project_steps_path
#     end
  # end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes!(params[:project])
    if @project.save
      respond_to do |format|
        format.js { render :js => @project.id }
      end
    end
  end

  def stripe_update
    code = params[:code]
    client = OAuth2::Client.new(ENV['STRIPE_CLIENT_ID'], ENV['STRIPE_KEY'], :site => "https://connect.stripe.com/oauth/authorize")
    token = client.auth_code.get_token(code, :headers => {'Authorization' => "Bearer #{ENV['STRIPE_KEY']}"})
    project = Project.find(session[:current_project])
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
    logger.debug(params[:id])
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
