class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :city, :state, :zip,
                  :neighborhood, :provider, :uid, :token, :organization, :mission, :subscribed, :avatar
                  
  after_create :send_welcome_email
  after_create :assign_default_badge
                  
  attr_accessor :avatar_upload_width, :avatar_upload_height
  # attr_accessible :title, :body

  validates_presence_of :first_name
   validates_presence_of :last_name
  # validate :minimum_image_size
  # validates_uniqueness_of :name, :email, :case_sensitive => false

  with_options dependent: :destroy do |user|
    user.has_many :services
    user.has_many :projects
    user.has_many :contacts
  end


  has_many :donations

  # Badging
  has_merit

  # mount_uploader :avatar, AvatarUploader

  def self.create_with_omniauth(info)
    create(name: info['name'])
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    
    unless user    
      user = User.create(  first_name:auth.extra.raw_info.name.to_s.split(' ')[0],
                           last_name: auth.extra.raw_info.name.to_s.split(' ')[1],
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20],
                           token:auth.credentials.token
                           )
      end
    user
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], :without_protection => true) do |user|
        user.attributes = params
        user.services.build(:provider => session["devise.provider"], :uid => session["devise.uid"])
        user.valid?
      end
    else
      super
    end
    #super.tap do |user|
    #  if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
    #    user.email = data["email"] if user.email.blank?
    #  elsif data = session["devise.twitter_data"]
    #    user.name = data["name"] if user.name.blank?
    #  end
    #end
  end

  def email_required?
    super && provider.blank?
  end

  def password_required?
    false
  end

  def projects_funded
    Project.joins(:donations).where("donations.user_id = ?", self.id).uniq
  end

  def amount_funded
    donations.sum(:amount)
  end

  def most_funded_city
    project = Project.select("projects.city, SUM(donations.amount) as city_sum").joins(:donations).
        where("donations.user_id = ?", self.id).group("projects.city").order("city_sum DESC").first
    # Return an empty string if user has no donations
    project.present? ? project.city : ""
  end

  private

  def send_welcome_email
    WelcomeMailer.welcome_confirmation(self).deliver
  end

  def assign_default_badge
    self.add_badge(1)
  end

  # def minimum_image_size
#     if self.avatar_upload_width && self.avatar_upload_height && (self.avatar_upload_width < 200 || self.avatar_upload_height < 200)
#       errors.add :avatar, "Image should be at least 200px x 200px"
#     end
#   end

end
