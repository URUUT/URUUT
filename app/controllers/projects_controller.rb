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
 #    @project.perks.build
 #    @project.galleries.build
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
    @project.update_attributes!(params[:project])
	end

	def show
		@project = Project.find(params[:id])
    @donation = Donation.where("project_id = ?", @project.id)
		@perks = Perk.where("project_id = ?", @project.id)
    @user = User.find(@project.user_id)
    session[:current_project] = @project.id
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
    client = OAuth2::Client.new('ca_0nuMjzTruvR2hOSuHDJSlxzeA7q4h5ai', 'sk_test_XF9K5nq63HTSmTK1ZMiW6tvw', :site => "https://connect.stripe.com/oauth/authorize")
    token = client.auth_code.get_token(code, :headers => {'Authorization' => 'Bearer sk_test_XF9K5nq63HTSmTK1ZMiW6tvw'})
    project = Project.find(session[:current_project])
    project.project_token = token.token
    project.save!

    redirect_to '/project_steps/step4', :param => "connected"
  end

  def save_image
    @project = Project.find_by_id(session[:current_project])
    @project.large_image = params[:large_image]

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
        format.js { render :js => perk.id }
      end
    end
  end

end
