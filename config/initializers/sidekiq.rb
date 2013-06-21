# config/initializers/sidekiq.rb
require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

Sidekiq.configure_server do |config|
  config.redis = { :size => 6 }
  database_url = ENV['DATABASE_URL']
    if database_url
      ENV['DATABASE_URL'] = "#{database_url}?pool=25"
      ActiveRecord::Base.establish_connection
    end
end