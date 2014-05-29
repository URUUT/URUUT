require 'stripe'

class Gateway::BaseService

  attr_reader :user, :customer

  def initialize(user)
    @user = user
  end

  def find_customer
    return false unless user.stripe_user_token

    @customer = Stripe::Customer.retrieve(user.stripe_user_token)
  end

  def find_card
    return false unless find_customer && user.stripe_card_token

    customer.cards.retrieve(user.stripe_card_token)
  end

end
