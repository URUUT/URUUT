APP_PATH = "/u/apps/techbridge"

worker_processes 4

working_directory "#{APP_PATH}/current" # available in 0.94.0+

listen "/tmp/.unicorn.sock", :backlog => 64
listen 8080, :tcp_nopush => true

timeout 30

pid "#{APP_PATH}/shared/pids/unicorn.pid"

stderr_path "#{APP_PATH}/shared/log/unicorn.stderr.log"
stdout_path "#{APP_PATH}/shared/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

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