Rails.application.config.middleware.use OmniAuth::Builder do
    # provider :facebook, '517310951621035', 'af19a657b1772fd82c1e5826f3a608f6'
    provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
end
