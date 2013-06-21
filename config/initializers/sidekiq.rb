# config/initializers/sidekiq.rb
if Rails.env.production? || Rails.env.staging?
  Sidekiq.configure_client do |config|
    config.redis = { :size => 1}
  end
end