class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :token, :user_id, :email
  attr_accessor :token

  belongs_to :project

  def save_with_payment
    current_user = :current_user
    Stripe.api_key = "sk_0EJjKro10y6bBBYfyZnCRgM2w8HOB"
      customer = Stripe::Customer.create(description: email, email: email, card: token)
      self.token = customer.id
      save!
  
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
end
