# Load the rails application
require File.expand_path('../application', __FILE__)

ENV['RAILS_ENV'] ||= 'development'

# Initialize the rails application
Crowdfund::Application.initialize!

AMOUNTS = [10, 25, 50, 100, 250]
LEVELS = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"]
