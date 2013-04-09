class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  after_create :send_welcome_email

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :city, :state, :zip, :neighborhood, :provider, :uid, :token
  # attr_accessible :title, :body

  validates_presence_of :name
  # validates_uniqueness_of :name, :email, :case_sensitive => false

  has_many :services, :dependent => :destroy
  has_many :projects, :dependent => :destroy

  def self.create_with_omniauth(info)
    create(name: info['name'])
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           token:auth.credentials.token
                           )
    end
    user
  end
  
  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           # email:'chad.bartels@hashfire.com',
                           password:Devise.friendly_token[0,20],
                           token:auth.credentials.token
                           )
                           user.save!
    end
    user
  end
  
  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      logger.debug(auth.extra.raw_info)
      user = User.create(name:auth.extra.raw_info.firstName +  " " + auth.extra.raw_info.lastName,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.extra.raw_info.emailAddress,
                           password:Devise.friendly_token[0,20],
                           token:auth.credentials.token
                           )
                           user.save!
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      elsif data = session["devise.twitter_data"]
        user.name = data["name"] if user.name.blank?
      end
    end
  end
  
  def password_required?
    super && provider.blank?
  end

  private

  def send_welcome_email
    ContactMailer.contact_confirmation(self).deliver
  end
end
