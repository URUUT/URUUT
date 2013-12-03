desc 'Close out completed projects and generate charges and tax reports'
namespace :uruut do
	task :finished_projects => [:environment] do
  	include ApplicationHelper

		projects = Project.live.ending_today
		projects.each do |project|
			if (totalsponsor(project) >= project.goal.to_f && project.goal.to_f > 0) || (project.partial_funding == true && project.goal.to_f > 0)
				project.update_attributes(status: "Funding Completed")
				user_ids = project.donations.select(:user_id).map(&:user_id).uniq
				unless user_ids.nil?
					user_ids.each do |user|
						User.find(user).generate_tax_report(project)
					end
				else
					puts "No Donations"
				end
				#puts "Project Successful"
			else
				project.update_attributes!(live: 0, status: "Funding Failed")
				#puts "Project Not Successful"
			end
		end
	end
end