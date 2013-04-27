class Sponsor < ActiveRecord::Base
  PAYMENT = ["Credit Card", "Wire Transfer"]
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :card_number, :payment_type,
                  :card_expiration, :cvc , :phone, :org_name, :mission, :month, :years, :card_name
  attr_accessor :org_name, :mission, :month, :years, :card_name
  # attr_accessible :title, :body
  has_many :project_sponsors

end
