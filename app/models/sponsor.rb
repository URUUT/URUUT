class Sponsor < ActiveRecord::Base
  PAYMENT = ["Credit Card", "Wire Transfer/Check"]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :payment_type,
                  :phone, :org_name, :mission, :card_name

  attr_accessor :card_name, :anonymous
  # attr_accessible :title, :body
  has_many :project_sponsors

  validates :card_name, presence: true, if: :payment_type_credit_card?
  validates :phone, :email, :name, presence: true, if: :payment_type_transfer?

  def payment_type_transfer?
    self.payment_type.eql? "Wire Transfer"
  end

  def payment_type_credit_card?
    self.payment_type.eql? "Credit Card"
  end

  def self.send_confirmation_email(sponsor)
    SponsorMailer.new_sponsor(sponsor).deliver
  end

  def self.sponsor_thank_you(sponsor, email)
    SponsorMailer.sponsor_thank_you(sponsor, email).deliver
  end

  def self.save_customer(current_user, project_sponsor)
    Stripe.api_key = "#{Settings.stripe.api_key}"
    name = current_user.first_name + ' ' + current_user.last_name
    description = "Name: #{name}, Email: #{current_user.email}, Payment Type: Sponsor"
    customer = Stripe::Customer.create(description: description, card: project_sponsor.card_token)
    project_sponsor.customer_id = customer.id
    project_sponsor.save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    # errors.add :base, "There was a problem with your credit card."
    false
  end

  def self.create_charge(project_sponsor)
    Stripe.api_key = "#{Settings.stripe.api_key}"
    customer = project_sponsor.customer_id
    auth_token = Project.find(project_sponsor.project_id).project_token
    logger.debug customer

    token = Stripe::Token.create(
      {:customer => customer},
      auth_token # user's access token from the Stripe Connect flow
    )

    Stripe::Charge.create({
        :amount => 1000, # in cents
        :currency => "usd",
        :token => token,
        :application_fee => 1000
    }, auth_token)

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    # errors.add :base, "There was a problem with your credit card."
    false
  end

end
