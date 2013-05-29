API_KEY = "pk_test_BTNPlS59UIPJC5Fnp7CR9It6'"
STRIPE_PUBLIC_KEY = "sk_test_Ydpgzl4aX7paVEPDaChNSP5Z"

Rails.configuration.stripe = {
  :publishable_key => STRIPE_PUBLIC_KEY,
  :secret_key      => API_KEY
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
