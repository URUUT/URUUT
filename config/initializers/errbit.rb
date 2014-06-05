Airbrake.configure do |config|
  config.api_key = ENV['errbit-api']
  config.host    = 'uruut-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end