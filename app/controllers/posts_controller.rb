class PostsController < ApplicationController

	def create
		@project = Project.find(params[:project_id])
		@post = @project.posts.build(params[:post])
		@post.user_id = current_user.id
		if @post.save
	      flash[:notice] = "Successfully created post."
	      respond_to :js
	    else
	      flash[:error] = "Error adding comment."
	    end
	end

	def create_post
		@project = Project.find(params[:project_id])
		@post = @project.posts.build(params[:post])
	end
end
