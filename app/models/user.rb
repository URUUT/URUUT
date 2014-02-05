class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me, :city, :state, :zip,
    :neighborhood, :provider, :role, :uid, :token, :organization, :mission, :subscribed, :avatar, :uruut_point,
    :telephone, :full_registration, :sign_in_plan

  after_create :send_welcome_email
  after_create :assign_default_badge

  attr_accessor :avatar_upload_width, :avatar_upload_height, :full_registration, :sign_in_plan
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
  has_many :tax_reports
  has_many :questions

  has_one :membership

  acts_as_tenant(:account)

  # Badging
  has_merit

  scope :unique_project_donors, ->(project) { joins(:donations).
    where(donations: { project_id: project.id, confirmed: true }).uniq }

  delegate :plan, to: :membership, prefix: true

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
          user.build_membership.save
          Gateway::CustomerService.new(user).create
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

  def generate_tax_report(project)
    donations = self.donations.where(project_id: project.id)
    total_donated = ActionController::Base.helpers.number_to_currency(donations.inject(0) {|sum, i| sum + i.amount}.to_f)
    first_name = self.first_name
    last_name = self.last_name
    perks = Perk.where(project_id: project.id).order("amount ASC")
    eligible_perk = perks.compact.find_all { |item| ActionController::Base.helpers.number_to_currency(item.amount) <= total_donated }.max
    eligible_perk_name = eligible_perk.nil? ? "None" : eligible_perk.name
    eligible_perk_description = eligible_perk.nil? ? " " : eligible_perk.description
    todays_date = Date.today
    # Implicit Block
    Prawn::Document.generate("tmp/#{project.organization[0..8].gsub(/\s+/, '')}_#{Date.today.strftime('%Y%m%d')}#{self.id}.pdf") do
      font_size 18
      pad(20) { text "#{project.organization}" }
      stroke_horizontal_rule

      font_size 12
      pad(20) { text "Date: #{todays_date}"}
      pad(20) { text "Donator Name: #{first_name} #{last_name}" }
      pad(20) { text "Total Donated: #{total_donated}" }

      pad(20) { text "Perk/Benefit Received: #{eligible_perk_name} - #{eligible_perk_description}" }
      stroke_horizontal_rule

      font_size 10
      pad(20) { text "No goods or services were received in exchange for the donation unless specified above.  It is recommended you seek advice from a tax professional." }
    end
    upload_to_s3("#{project.organization[0..8].gsub(/\s+/, '')}_#{Date.today.strftime('%Y%m%d')}#{self.id}.pdf", project)
  end

  def upload_to_s3(filename, project)
    s3 = AWS::S3.new
    bucket = s3.buckets['uruut/tax_reports']
    obj = bucket.objects[filename]
    obj.write(:file => "#{Rails.root}/tmp/#{filename}")
    url = obj.public_url.to_s
    save_url(url, project)
  end

  def save_url(url, project)
    tax_report = self.tax_reports.new
    tax_report.update_attributes(url: url, project_id: project.id)
  end

  def is_admin?
    role == 'admin'
  end

  def donor?
    membership_plan.blank?
  end

  def campaign_manager?
    !donor?
  end

private

  def send_welcome_email
    WelcomeMailer.welcome_confirmation(self).deliver
  end

  def assign_default_badge
    self.add_badge(1)
  end



end
