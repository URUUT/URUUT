class ProjectsController < ApplicationController
	before_filter :authenticate_user!
	
	def index
	end

	def new
		session[:project_params] ||= {}
		@project = Project.new
		# @project.images.build
		# @project.videos.build
		# respond_to do |format|
	 #      format.html # new.html.erb
	      # format.xml  { render :xml => @project }
	    # end
	end

	def create
		session[:project_params].deep_merge!(params[:project]) if params[:project]
		@project = Project.new(session[:project_params])
		@project.current_step = session[:project_step]

		if params[:back_button]
			@project.previous_step
		elsif @project.last_step?
			@project.save
			# @project.images.build
		else
			params[:project][:image] = nil
			@project.next_step
		end
		session[:project_step] = @project.current_step
		if @project.new_record?
			render 'new'
		else

			session[:project_step] = session[:project_params] = nil
			params[:project][:image] = nil rescue nil
			redirect_to @project
		end
	end

	def show
		@project = Project.find(:all)
	end
end
