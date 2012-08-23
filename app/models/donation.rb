class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :token, :user_id, :email

  def save_with_payment(stripe_token)
   
    Stripe.api_key = "sk_0EJjKro10y6bBBYfyZnCRgM2w8HOB"
      customer = Stripe::Customer.create(description: current_user.email, email: current_user.email, card: stripe_token)
      self.token = customer.id
      save!
  
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end
