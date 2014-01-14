require 'stripe'

class Gateway::CustomerService

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def create
    return false if user.stripe_user_token

    response = Stripe::Customer.create(email: user.email)

    user.stripe_user_token = response.id
    user.save
  end

end