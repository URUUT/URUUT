desc 'Access helper methods in rake tasks'
namespace :uruut do
	task :finished_projects => [:environment] do
  	include ApplicationHelper

		projects = Project.live.ending_today
		projects.each do |project|
			if totalsponsor(project) >= project.goal.to_f && project.goal.to_f > 0
				project.update_attributes(status: "Funding Completed")
				#puts "Project Successful"
			else
				project.update_attributes(live: 0, status: "Funding Failed")
				#puts "Project Not Successful"
			end
		end
	end
end