API_KEY = ENV['STRIPE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUB_KEY']
STRIPE_CLIENT_ID = ENV['STRIPE_CLIENT_ID']

Rails.configuration.stripe = {
  :publishable_key => STRIPE_PUBLIC_KEY,
  :secret_key      => API_KEY
}

Stripe.api_key = API_KEY
