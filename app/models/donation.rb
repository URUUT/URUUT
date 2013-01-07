class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :customer_token, :user_id, :email, :token
  attr_accessor :token

  belongs_to :project

  def save_with_payment
    current_user = :current_user
    Stripe.api_key = "sk_0EJjKro10y6bBBYfyZnCRgM2w8HOB"
    customer = Stripe::Customer.create(description: email, email: email, card: token)
    self.customer_token = customer.id
    save!
  
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def self.already_donated(project, user)
  	@donation = Donation.where("project_id = ? AND user_id = ?", project, user)
  	if @donation.length == 0
  		return nil
  	else
  		return @donation.first.amount
  	end
  end

  def self.edit_donation(project, user)
  	@donation = Donation.where("project_id = ? AND user_id = ?", project, user)
  	return @donation.first.id
  end

end
