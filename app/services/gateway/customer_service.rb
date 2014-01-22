require 'stripe'

class Gateway::CustomerService < Gateway::BaseService

  def create
    return false if user.stripe_user_token

    response = Stripe::Customer.create(email: user.email)

    user.stripe_user_token = response.id
    user.save
  end

end