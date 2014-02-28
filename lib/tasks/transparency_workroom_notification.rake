require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "This task check for updates in transparency workroom"
task :schedule_test => :environment do
  
    puts "Sending Mail..."
    TransparencyWorkroom.delay.transparency_workroom_update(user, project)
    puts "done."

end