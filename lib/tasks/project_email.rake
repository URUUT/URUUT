require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "This task will be called by the Heroku scheduler add-on"
task :schedule_test => :environment do
  puts "Sending Mail..."
  ContactMailer.delay.contact_confirmation('Chad', 'chad.bartels@gmail.com', 'test', 'test')
  puts "done."
end