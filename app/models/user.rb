class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :city, :state, :zip,
    :neighborhood, :provider, :role, :uid, :token, :organization, :mission, :subscribed, :avatar, :uruut_point

  after_create :send_welcome_email
  after_create :assign_default_badge

  attr_accessor :avatar_upload_width, :avatar_upload_height
  # attr_accessible :title, :body

  validates_confirmation_of :password
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email

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
          user = User.create!(
            first_name:auth.extra.raw_info.name.to_s.split(' ')[0],
            last_name: auth.extra.raw_info.name.to_s.split(' ')[1],
            provider:auth.provider,
            uid:auth.uid,
            email:auth.info.email,
            password:password,
            password_confirmation:password,
            token:auth.credentials.token,
            avatar: auth.info.image
          )
        # elsif type.eql?("linkedln")
        #   user = User.create(
        #     first_name:auth.info.name.to_s.split(' ')[0],
        #     last_name: auth.info.name.to_s.split(' ')[1],
        #     provider:auth.provider,
        #     uid:auth.uid,
        #     email:auth.info.email,
        #     password:password,
        #     password_confirmation:password,
        #     token:auth.credentials.token
        #   )
        # else
        #   user = User.create(
        #     first_name: auth['info']['name'].to_s.split(" ")[0],
        #     last_name: auth['info']['name'].to_s.split(" ")[1],
        #     provider:auth.provider,
        #     uid:auth.uid,
        #     email: "#{auth.info.nickname}@uruut.com",
        #     password:password,
        #     password_confirmation:password,
        #     token:auth.credentials.token)
        end
      else
        user.update_attributes!({provider: auth.provider,uid: auth.uid})
      end
    end
    user
  end

  def self.set_redirect_path
    session.delete(:path)
    project = Project.new
    project.user_id = resource.id
    project.save!
    "/projects/#{project.id}/edit#sponsor-info"
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
  end

  def create_facebook_user(omni)
    self.email = omni['extra']['raw_info'].email
    self.apply_omniauth(omni)

    if self.save
      flash[:notice] = "Logged in."
      sign_in_and_redirect User.find(self.id)
    else
      session[:omniauth] = omni.except('extra')
      redirect_to new_user_registration_path
    end
  end

  def email_required?
    super && provider.blank?
  end

  def password_required?
    false
  end

  def projects_funded
    Project.joins(:donations).where("donations.user_id = ? AND donations.confirmed = #{true}", self.id).uniq
  end

  def amount_funded
    donations.sum(:amount)
  end

  def most_funded_city
    donation = self.donations.order("created_at DESC").first
    donation.nil? ? "" : donation.project.city
  end

  def generate_tax_report
    donations = self.donations
    donations.inject(0) {|sum, i| sum + i.amount}

    # Implicit Block
    Prawn::Document.generate("reports/tax_report.pdf") do
     text "#{donations.inject(0) {|sum, i| sum + i.amount}}"
    end
  end

  private

  def send_welcome_email
    WelcomeMailer.welcome_confirmation(self).deliver
  end

  def assign_default_badge
    self.add_badge(1)
  end


end
