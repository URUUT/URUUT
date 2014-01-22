require 'stripe'

class Gateway::CardsService < Gateway::BaseService

  def create(credit_card)
    return false unless find_customer

    response = customer.cards.create(
      card: credit_card.details_as_hash
    )

    customer.default_card = response.id
    customer.save

    user.stripe_card_token = response.id
    user.save
  end

end