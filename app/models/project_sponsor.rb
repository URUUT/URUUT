class ProjectSponsor < ActiveRecord::Base
  #mount_uploader :logo, LogoUploader

  attr_accessible :card_token, :cost, :logo, :mission, :name, :project_id,
  :sponsor_id, :level_id, :payment, :status, :card_type, :card_last4, :created_at, :site, :confirmed, :sponsor_type

  attr_accessor :type_founder

  belongs_to :project
  belongs_to :sponsor
  belongs_to :sponsorship_level, foreign_key: :level_id

  validates :name, :logo, :mission, :level_id, presence: true

  validates_length_of :mission, maximum: 275

  default_scope { where(confirmed: true) }
  
  def self.save_customer
    logger.debug "Save With Payment Working?"
    current_user = :current_user
    Stripe.api_key = "#{Settings.stripe.api_key}"
    customer = Stripe::Customer.create(description: current_user.email, card: card_token)
    ProjectSponsor.customer_token = customer.id
    save!

  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end
  
end
