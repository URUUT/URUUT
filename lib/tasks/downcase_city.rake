require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

task :downcase_city => :environment do
	projects = Project.all
  projects.each do |c|
    unless c.nil?
      c.city.downcase
      c.update_attributes!(:city => c.city)
    end
  end
end