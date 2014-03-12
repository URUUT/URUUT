Airbrake.configure do |config|
  config.api_key = '0b0c7afbf771f20aaf92ef9ca90bc90b'
  config.host    = 'uruut-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end