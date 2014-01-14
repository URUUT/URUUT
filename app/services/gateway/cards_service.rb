require 'stripe'

class Gateway::CardsService < Gateway::BaseService

  def create(number, exp_month, exp_year, cvc)
    return false unless find_customer

    customer.cards.create(
      number:    number,
      exp_month: exp_month,
      exp_year:  exp_year,
      cvc:       cvc
    )
  end

end