# lib/tasks/helper_task.rake
desc 'Access helper methods in rake tasks'
task :rake_helper_test => [:environment] do
  projects = Project.where("live = ?", 1)
  projects.each do |p|
    date_end = p.campaign_deadline.to_date - Date.today
    if date_end < 1
      p.live == 0
      p.save!
    end
  end
end