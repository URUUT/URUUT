class ProjectsController < ApplicationController
	require 'bitly'

  before_filter :authenticate_user!, :only => [:index, :new, :create, :edit, :update]
  
	def index
		@projects = Project.find_all_by_user_id(current_sponsor.id)
  end

	# def new
	#     @project = Project.new
	#     @default = Project.default_value 
	#     perks = @project.perks.build
	#     galleries = @project.galleries.build
	#     respond_to do |format|
	#         format.html # new.html.erb
	#         format.xml  { render :xml => @project }
	#       end
	#   end

	def create
		@project = Project.new(params[:project])
    @project.user = current_user
    if @project.save
      logger.debug("Project ID is #{@project.id}")
      bitly = Bitly.new('chadbartels','R_b1c64c4fb7afc739d0e2da6bcdaf946b')
      page_url = bitly.shorten("#{request.scheme}://#{request.host_with_port}/projects/#{@project.id}")
      @project.bitly = page_url.short_url
      @project.save!

      session[:current_project] = @project.id
      session[:current_step] = "step1"
      logger.debug("current step is " + session[:current_step])
      redirect_to :action => "step2"
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

  def step1
    @project = Project.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  def step2
    @project = Project.find(session[:current_project])
    galleries = @project.galleries.build
    @project.update_attributes(params[:project])
    method = params[:_method]
    if method.nil?
      logger.debug("Nothing for Method")
    else
      logger.debug("Method is " + method)
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
      logger.debug("Method is " + method)
      redirect_to :action => "step3"
    end
  end

  def step4
    @project = Project.find(session[:current_project])
    session[:current_url] = "#{request.protocol}#{request.host_with_port}#{request.fullpath}"
  end
end
