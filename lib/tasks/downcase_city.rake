task :downcase_city => :environment do
	cities = Project.pluck(:city)
	cities.each do |c|
		c.downcase!
	end
end