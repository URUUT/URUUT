uri = URI.parse(ENV["REDISTOGO_URL"])
if Rails.env == 'development' || Rails.env == 'staging'
	REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
elsif Rails.env.production?
  REDIS = Redis.new(:host => uri.host, :port => uri.port)
end