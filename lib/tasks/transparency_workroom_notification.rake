require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "This task check for updates in transparency workroom"
task :transparency_workroom_notification => :environment do
  Project.find_in_batches do |groups|
    groups.each do |project|
      if project.transparency_workroom_updated_since?(1.day.ago)
        donor_ids = project.donors.map(&:id).uniq
        donors    = User.where(id: donor_ids)

        donors.each do |donor|
          TransparencyWorkroomMailer.transparency_workroom_update(donor, project).deliver
        end

        sponsor_emails = project.sponsors.map(&:email).uniq
        sponsor_emails.each do |email|
          sponsor = Sponsor.find_by_email(email)
          TransparencyWorkroomMailer.transparency_workroom_update(sponsor, project).deliver
        end
      end
    end
  end
end