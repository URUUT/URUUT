require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

desc "Send Sponsor Thank You Email"
namespace :email do
	task :sponsor_thank_you => :environment do
	    Sponsor.sponsor_thank_you(1, 'chad.bartels@gmail.com').deliver
	end
end
