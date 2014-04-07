require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "This task check for updates in transparency workroom"
task :transparency_workroom_notification => :environment do
  Project.find_in_batches do |groups|
    groups.each do |project|
      if project.transparency_workroom_updated_since?(1.day.ago)
        project.donations.each do |donation|
          TransparencyWorkroomMailer.transparency_workroom_update(donation.user, project).deliver
        end

        project.sponsors.each do |sponsor|
          TransparencyWorkroomMailer.transparency_workroom_update(sponsor, project).deliver
        end
      end
    end
  end
end