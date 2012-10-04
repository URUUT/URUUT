class ProjectsController < ApplicationController
	before_filter :authenticate_user!, :only => [:index, :new, :create, :edit, :update]
	def index
		@projects = Project.find_all_by_user_id(current_user.id)
	end

	def new
		@project = Project.new
		respond_to do |format|
	      format.html # new.html.erb
	      format.xml  { render :xml => @project }
	    end
	end

	def create
		@project = Project.new(params[:project])
		@project.user = current_user
		if @project.save
			redirect_to @project
		end
	end

	def edit
		@project = Project.find(params[:id])
	end

	def show
		@project = Project.find(params[:id])
		tags = @project.tags
		@tags = tags.split(',')
		session[:current_project] = @project.id
	end

	def update  
		@project = Project.find(params[:id])  
		if @project.update_attributes(params[:project])  
			flash[:notice] = "Successfully updated project."  
		end  
		respond_with(@project)  
	end  
end
