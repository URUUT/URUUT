require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "Send milestone email"
task :milestone_email => :environment do
  projects = Project.where("live = ?", 1)
  projects.each do |p|
    goal = p.goal
    donations = Donation.where("project_id = ?", p.id)
    total = donations.inject(0){ |sum,e| sum += e.amount }
    percent = (total.to_f/goal.to_f)
    puts "Total is #{total}"
    puts "Goal is #{goal}"
    puts "Percent to goal is #{percent}%"
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
      puts "15 Percent"
    else
      puts "It needs to fund further"
    end
  end
end