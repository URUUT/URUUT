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
	end

	def create
		@project = Project.new(params[:project])
    #@project.user = current_user
    if @project.save
      #bitly = Bitly.new('chadbartels','R_b1c64c4fb7afc739d0e2da6bcdaf946b')
      #page_url = bitly.shorten("#{request.scheme}://#{request.host_with_port}/projects/#{@project.id}")
      #@project.bitly = page_url.short_url
      #@project.save!

      session[:current_project] = @project
      session[:started] = 1
      redirect_to project_steps_path 
    else
      render :new
		end
	end

	def edit
		@project = Project.find(params[:id])
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
    logger.debug(code)
    
    client = OAuth2::Client.new('ca_0nuMjzTruvR2hOSuHDJSlxzeA7q4h5ai', 'sk_test_XF9K5nq63HTSmTK1ZMiW6tvw', :site => "https://connect.stripe.com/oauth/authorize")
    token = client.auth_code.get_token(code, :headers => {'Authorization' => 'Bearer sk_test_XF9K5nq63HTSmTK1ZMiW6tvw'})
    logger.debug(token.token)
    # response = token.post('https://connect.stripe.com/oauth/token', :params => { 'code' => code, 'grant_type' => 'refresh_token' })
    #     logger.debug(response)
    
    logger.debug("last page was: #{session[:current_url]}")
    project = Project.find(session[:current_project])
    project.project_token = token.token
    project.save!
    
    redirect_to session[:current_url], :param => "connected"
  end

  def step1
    @project = Project.new
    perks = @project.perks.build
    galleries = @project.galleries.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  def step2
    @project = Project.find(session[:current_project])
    @project.update_attributes(params[:project])
    method = params[:_method]
    if method.nil?
      logger.debug("Nothing for Method")
    else
      # logger.debug("Method is " + method)
      redirect_to :action => "step3"
    end
  end
  
  def step3
    @project = Project.find(session[:current_project])
    perks = @project.perks.build
    method = params[:_method]
    if method.nil?
      logger.debug("Nothing for Method")
    else
      # logger.debug("Method is " + method)
      redirect_to :action => "step4"
    end
  end

  def step4
    @project = Project.find(session[:current_project])
    session[:current_url] = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end
end
