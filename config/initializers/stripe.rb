API_KEY = "sk_test_VpCit4b4YmZzlItS0Z9oBDlJ"
STRIPE_PUBLIC_KEY = "pk_test_TjJ8AY0vlqBFrOWuhAvPR2br"

Rails.configuration.stripe = {
  :publishable_key => "pk_test_BTNPlS59UIPJC5Fnp7CR9It6",
  :secret_key      => "sk_test_Ydpgzl4aX7paVEPDaChNSP5Z"
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]