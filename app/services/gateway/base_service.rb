require 'stripe'

class Gateway::BaseService

  attr_reader :user, :customer

  def initialize(user)
    @user = user
  end

  def find_customer
    return false unless user.stripe_user_token

    @customer = Stripe::Customer.retrieve(stripe_user_token)
  end

end