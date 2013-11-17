if Rails.env.production? || Rails.env.development?
	uri = URI.parse(ENV["REDISTOGO_URL"])
	REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end