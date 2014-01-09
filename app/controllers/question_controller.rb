class QuestionController < ApplicationController
	def create
		@question = Question.new(params[:question])
		@question.user = current_user
		if @question.save
	      flash[:notice] = "Successfully send question."
	      user_name = "#{current_user.first_name} #{current_user.last_name}"
	      QuestionMailer.send_question(user_name, current_user.email, @question.subject, @question.body).deliver
	      redirect_to :back
	    else
	      flash[:error] = "Error question."
	    end
	end
end
