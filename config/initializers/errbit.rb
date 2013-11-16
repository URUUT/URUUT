Airbrake.configure do |config|
  config.api_key = '4881a9b2f302f8be1869975521664871'
  config.host    = 'uruut-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end