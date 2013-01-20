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
    perks = @project.perks.build
    galleries = @project.galleries.build
  end

	def create
		@project = Project.new(params[:project])
    @project.status = 'step1'
    if @project.save
      bitly = Bitly.new('chadbartels','R_b1c64c4fb7afc739d0e2da6bcdaf946b')
      page_url = bitly.shorten("#{request.scheme}://#{request.host_with_port}/projects/#{@project.id}")
      @project.bitly = page_url.short_url
      @project.save!

      session[:current_project] = @project.id
      session[:started] = 1
      redirect_to project_steps_path 
    else
      render :new
		end
	end

	def edit
		@project = Project.find(params[:id])
    session[:current_project] = @project.id
    redirect_to project_steps_path
	end

	def show
		@project = Project.find(params[:id])
    @donation = Donation.where("project_id = ?", @project.id)
		@perks = Perk.where("project_id = ?", @project.id)
    @user = User.find(@project.user_id)
    session[:current_project] = @project.id
	end

	def update  
		@project = Project.find(params[:id])  
		if @project.update_attributes(params[:project])  
			flash[:notice] = "Successfully updated project."  
      redirect_to @project
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

end
