API_KEY = ""
STRIPE_PUBLIC_KEY = ""

Rails.configuration.stripe = {
  :publishable_key => STRIPE_PUBLIC_KEY,
  :secret_key      => API_KEY
}

Stripe.api_key = ""
