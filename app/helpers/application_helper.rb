module ApplicationHelper

	def current_project
		session[:current_project]
	end

	def percent_funded(id)
		project = Project.find(id)
		donation = Donation.where("project_id = ?", id)
		total_funded = 0.0
		donation.each do |d|
			total_funded = total_funded + d.amount.to_f
		end
		percentage = total_funded/project.goal
		
		return percentage.round(2) * 100
		# return total_funded
		# return percentage
		# return total_funded
	end

	def get_user(id)
		user = User.find_by_id(id)
		return user.name
	end
	
end
