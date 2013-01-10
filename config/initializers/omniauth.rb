Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_KEY, FACEBOOK_SECRET
  provider :linkedin, LINKEDIN_KEY, LINKEDIN_SECRET
end