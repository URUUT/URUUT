require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "Send milestone email"
namespace :uruut do
	task :milestone_email => :environment do
		projects = Project.where("live = ?", 1)
		projects.each do |p|
			mailer = Milestoneemail.find_by_project_id(p.id)
			unless mailer.blank?
				puts "Mailer is: #{mailer.id}"
			else
				mailer = Milestoneemail.create(:project_id => p.id)
			end
			goal = p.goal
			donations = Donation.where("project_id = ?", p.id)
			puts donations.size
			donors = donations.uniq_by{|donation| donation.user_id}
			puts donors.size
			total = donations.inject(0){ |sum,e| sum += e.amount }
			percent = (total.to_f/goal.to_f)
			infinity = 1.0 / 0.0

			case percent
			when 1.0..infinity
				puts "Completely Funded"
			when 0.90..0.99
				puts "90 Percent"
			when 0.75..0.89
				puts "90 Percent"
			when 0.50..0.74
				puts "50 Percent"
			when 0.15..0.49
				unless mailer.blank?
					unless mailer.fifteen_percent == true
						puts "Mail this bitch"
						donors.each do |donor|
							user = User.find(donor.user_id)
							puts user.first_name
							puts user.email
							puts percent
							puts p.id
							Milestoneemail.send_milestone_email(user.email, percent, p.id)
						end
						mailer.fifteen_percent = true
						#mailer.save!
					else
						puts "Already been mailed"
					end
				end
			else
				puts "It needs to fund further"
			end
		end
	end
end
