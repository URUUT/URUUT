module PaymentHelper
  def car_type_logo(card)
    case card.type
    when "Visa"
      "logo_visa.png"
    when "MasterCard"
      "logo_mastercard.png"
    when "American Express"
      "logo_american_express.png"
    when "Discover"
      "logo_discover.png"
    when "Diners Club"
      "logo_dinners.png"
    else
      "logo_jcb.png"
    end
  end
end
