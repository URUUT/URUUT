require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "This task check for updates in transparency workroom"
task :transparency_workroom_notification => :environment do
  Project.updated_yesterday.each do |project|
    project.donations.each do |donation|
      TransparencyWorkroom.transparency_workroom_update(donation.user, project).deliver
    end
  end
end