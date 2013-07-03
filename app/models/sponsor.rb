class Sponsor < ActiveRecord::Base
  PAYMENT = ["Credit Card", "Wire Transfer/Check"]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :payment_type,
                  :phone, :org_name, :mission, :card_name

  attr_accessor :card_name
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
  
  def self.sponsor_thank_you(sponsor)
    SponsorMailer.sponsor_thank_you(sponsor).deliver
  end
end
