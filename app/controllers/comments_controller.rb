class CommentsController < ApplicationController
	def create

		post = Post.find(params[:comment][:post_id])
		comment = post.comments.build(params[:comment])
		comment.user_id = current_user.id
		if comment.save
	      flash[:notice] = "Successfully created post."
	      redirect_to :back
	    else
	      flash[:error] = "Error adding comment."
	    end
	end
end
