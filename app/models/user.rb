class User < ActiveRecord::Base
  easy_roles :roles
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :async

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :city, :state, :zip,
    :neighborhood, :provider, :uid, :token, :organization, :mission, :subscribed, :avatar, :uruut_point

  # after_create :send_welcome_email
  after_create :assign_default_badge

  attr_accessor :avatar_upload_width, :avatar_upload_height
  # attr_accessible :title, :body

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :password_confirmation

  # validate :minimum_image_size
  validates_uniqueness_of :email, :case_sensitive => false

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

  def self.find_for_social_oauth(auth, signed_in_resource=nil, type)
    user = User.where(:provider => auth.provider.to_s, :uid => auth.uid.to_s).first
    unless user
      user = User.where(:email => auth.info.email).first
      unless user
        password = Devise.friendly_token[0,20]
        if type.eql?("facebook")
          user = User.create(
            first_name:auth.extra.raw_info.name.to_s.split(' ')[0],
            last_name: auth.extra.raw_info.name.to_s.split(' ')[1],
            provider:auth.provider,
            uid:auth.uid,
            email:auth.info.email,
            password:password,
            password_confirmation:password,
            token:auth.credentials.token
          )
        elsif type.eql?("linkedln")
          user = User.create(
            first_name:auth.info.name.to_s.split(' ')[0],
            last_name: auth.info.name.to_s.split(' ')[1],
            provider:auth.provider,
            uid:auth.uid,
            email:auth.info.email,
            password:password,
            password_confirmation:password,
            token:auth.credentials.token
          )
        else
          user = User.create(
            first_name: auth['info']['name'].to_s.split(" ")[0],
            last_name: auth['info']['name'].to_s.split(" ")[1],
            provider:auth.provider,
            uid:auth.uid,
            email: "#{auth.info.nickname}@uruut.com",
            password:password,
            password_confirmation:password,
            token:auth.credentials.token)
        end
      else
        user.update_attributes({provider: auth.provider,uid: auth.uid})
      end
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
    donation = self.donations.order("created_at DESC").first
    donation.nil? ? "" : donation.project.city
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
