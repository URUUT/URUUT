class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :customer_token, :user_id, :email, :token,
  :card_last4, :created_at, :card_type, :perk_name, :confirmed
  attr_accessor :token, :card_last4, :card_type, :type_founder

  belongs_to :project
  belongs_to :user

  default_scope { where(confirmed: true) }

  def save_with_payment
    logger.debug(token)
    current_user = :current_user
    Stripe.api_key = "sk_test_XF9K5nq63HTSmTK1ZMiW6tvw"
    customer = Stripe::Customer.create(description: email, card: token)
    self.customer_token = customer.id
    self.confirmed = true
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
