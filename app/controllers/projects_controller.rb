class ProjectsController < ApplicationController
	def index
	end

	def new
		@project = Project.new
		@project.images.build
		# @project.videos.build
		respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
	end

	def create
		@project = Project.create(params[:project])
	end

	def show
		@project = Project.find(:all)
	end
end
