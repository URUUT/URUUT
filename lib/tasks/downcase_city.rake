task :downcase_city => :environment do
	cities = Project.city.all
	logger.debug(cities.size)
	cities.each do |c|
		c.downcase
	end
	cities.save :validate => "false"
end