class Service < ActiveRecord::Base
  attr_accessible :uid, :provider
  belongs_to :user

  def self.from_omniauth(auth)

  end
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = Service.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = Service.create(name:auth.extra.raw_info.name,
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
    user = Service.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = Service.create(name:auth.info.name,
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
    user = Service.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      logger.debug(auth.extra.raw_info)
      user = Service.create(name:auth.extra.raw_info.firstName +  " " + auth.extra.raw_info.lastName,
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
  
end
