API_KEY = ENV['STRIPE_KEY']
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUB_KEY']

Rails.configuration.stripe = {
  :publishable_key => STRIPE_PUBLIC_KEY,
  :secret_key      => API_KEY
}

Stripe.api_key = ""
