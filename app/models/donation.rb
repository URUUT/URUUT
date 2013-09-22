class Donation < ActiveRecord::Base
  attr_accessible :amount, :project_id, :customer_token, :user_id, :email, :token,
  :card_last4, :created_at, :card_type, :perk_name, :confirmed, :description
  attr_accessor :token, :card_last4, :card_type, :type_founder

  belongs_to :project
  belongs_to :user

  default_scope { where(confirmed: true) }

  def save_with_payment
    current_user = :current_user
    Stripe.api_key = "#{Settings.stripe.api_key}"
    customer = Stripe::Customer.create(description: email, card: token)
    self.customer_token = customer.id
    self.confirmed = true
    save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  ###  new function for handle Stripe error  ###

  def error_payment?
    error = false
    Stripe.api_key = "#{Settings.stripe.api_key}"
    begin
      customer = Stripe::Customer.create(description: email, card: token)
    rescue Stripe::CardError => e
      error = e.message
    end
    error
  end

  #####################################################

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

  def self.send_confirmation_email(donation)
    DonationMailer.donation_confirmation(donation).deliver
  end

end
