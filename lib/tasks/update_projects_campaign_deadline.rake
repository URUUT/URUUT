namespace :projects do
  namespace :update do

    desc 'Updates projects campaign deadline to cover the end of day of current deadline'
    task campaign_deadline: :environment do
      Project.find_in_batches do |group|
        group.each do |project|
          if project.campaign_deadline
            project.campaign_deadline = project.campaign_deadline.end_of_day
            project.save
          end
        end
      end
    end

  end
end