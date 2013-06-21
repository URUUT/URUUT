worker_processes 3
timeout 30
preload_app true
#listen 4040

before_fork do |server, worker|
  
  @sidekiq_pid ||= spawn("bundle exec sidekiq -c 2")
  
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  # If you are using Redis but not Resque, change this
   if defined?(Resque)
     Resque.redis.quit
     Rails.logger.info('Disconnected from Redis')
   end

  sleep 1
end

after_fork do |server, worker|
  # Replace with MongoDB or whatever
   if defined?(ActiveRecord::Base)
     ActiveRecord::Base.establish_connection
     Rails.logger.info('Connected to ActiveRecord')
   end

  # If you are using Redis but not Resque, change this
   if defined?(Resque)
     Resque.redis = ENV['REDIS_URI']
     Rails.logger.info('Connected to Redis')
   end

  Sidekiq.configure_client do |config|
    config.redis = { :size => 1 }
  end
  
  Sidekiq.configure_server do |config|
    config.redis = { :size => 5 }
  end
  
end
