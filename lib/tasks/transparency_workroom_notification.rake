require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "This task check for updates in transparency workroom"
task :schedule_test => :environment do
  projects = get_updated_projects
  projects.each do |project|
    donors = get_donors(project)
    donors.each do |donor|
      send_email_to_donor(donor, project)
    end
  end
end

def get_updated_projects
  Project.all(conditions: ["updated_at >= ?", Date.yesterday])
end

def get_donors(project)
  Donation.where("project_id = ? AND customer_token != ?", project.id, '')
end

def send_email_to_donor(donor, project)
  puts "Sending Mail..."
  TransparencyWorkroom.transparency_workroom_update(donor, project).deliver
  puts "done."
end