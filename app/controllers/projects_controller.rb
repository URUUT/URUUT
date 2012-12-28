class ProjectsController < ApplicationController
	require 'bitly'

  before_filter :authenticate_user!, :only => [:index, :new, :create, :edit, :update]
  
	def index
		@projects = Project.find_all_by_user_id(current_sponsor.id)
  end

	def new
		@project = Project.new
    @default = Project.default_value 
		perks = @project.perks.build
    respond_to do |format|
	      format.html # new.html.erb
	      format.xml  { render :xml => @project }
	    end
	end

	def create
		@project = Project.new(params[:project])
    @project.user = current_user
    if @project.save
      logger.debug("Project ID is #{@project.id}")
      bitly = Bitly.new('chadbartels','R_b1c64c4fb7afc739d0e2da6bcdaf946b')
      page_url = bitly.shorten("#{request.scheme}://#{request.host_with_port}/projects/#{@project.id}")
      logger.debug("Testing URL: #{request.scheme}://#{request.host_with_port}/projects/#{@project.id}")
      @project.bitly = page_url.short_url
      @project.save!

      redirect_to @project
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
end
