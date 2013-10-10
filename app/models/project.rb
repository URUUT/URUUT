class Project < ActiveRecord::Base
  belongs_to :user

  before_save :downcase_url_and_facebook

  attr_accessible :category, :description, :duration, :goal, :address, :project_title, :sponsorship_permission,
  :city, :state, :zip, :neighborhood, :title, :image, :video, :tags, :live, :short_description, :perk_permission,
  :perks_attributes, :galleries_attributes, :status, :organization, :website, :twitter_handle, :facebook_page, :seed_video,
  :story, :about, :large_image, :seed_image, :cultivation_image, :ready_for_approval, :organization_type, :cultivation_mime_type,
  :organization_classification, :cultivation_video, :campaign_deadline, :sponsor_permission, :step, :seed_mime_type

  attr_accessor :sponsorship_permission, :perk_type
  #validates :title, :short_description, :description, :presence => true, :if => :active?
  #validates :image, :address, :city, :state, :zip, :neighborhood, :duration, :goal, :presence => true, :if => :active_or_step1?

  with_options dependent: :destroy do |project|
    project.has_many :donations
    project.has_many :perks
    project.has_many :galleries
    project.has_many :project_updates
    project.has_many :project_sponsors
    project.has_many :sponsorship_benefits
  end

  has_many :sponsorship_levels
  accepts_nested_attributes_for :perks, allow_destroy: true
  accepts_nested_attributes_for :galleries, allow_destroy: true

  scope :live, where("live = 1")

  def self.unique_values_of(type)
    self.select(type).uniq.pluck(type)
  end

  def self.by_city(city)
    (city && city.downcase != "all cities") ? where("city = ?", city) : where("")
  end

  def self.by_category(category)
    (category && category.downcase != "all categories") ? where("category = ?", category) : where("")
  end

  def self.by_keyword(keyword)
    where("city LIKE :keyword OR state LIKE :keyword OR title LIKE :keyword OR description LIKE :keyword OR organization LIKE :keyword", :keyword => "%#{keyword}%")
  end

  def self.get_sponsor_token
    if :current_user
      Stripe.api_key = API_KEY
    end
  end

  def distinct_donors
    project_donations = self.donations
    anonymous_donors = project_donations.select { |donation| donation.anonymous }.uniq_by { |donation| donation.user_id }
    real_donors = project_donations.select { |donation| !donation.anonymous }.uniq_by { |donation| donation.user_id }
    donors = (anonymous_donors + real_donors).sort_by {|donor| donor.updated_at }.reverse
    donations.select("DISTINCT(donations.user_id)")
  end

  def individual_donors(page_num)
    project_donations = self.donations
    anonymous_donors = project_donations.select { |donation| donation.anonymous }
    real_donors = project_donations.select { |donation| !donation.anonymous }
    donations_data = individual_donors_by_type(real_donors) + individual_donors_by_type(anonymous_donors)

    donations_group = group_and_sort_donor(donations_data, self.id)
    donations = donations_group.map { |donation| donation[1] }.flatten
    Kaminari.paginate_array(donations).page(page_num).per(25)
  end

  def individual_donors_by_type(donors)
    donations_data = []
    users_data = donors.group_by { |donation| donation.user_id }.map {|donation| [ donation[0], total_donation_by_user(donation[1]), last_donation_by_user(donation[1]), donation[1].first.anonymous ] }
    donations_levels = group_and_sort_donor(self.donations, self.id)
    donations_levels_and_amount = donations_levels.map { |donation| [ donation[0], get_amount_by_perk_name(donation[0], self.id) ] }

    users_data.each do |user|
      levels = []
      donations_levels_and_amount.each do |donation_level|
        if user[1] >= donation_level[1]
          levels << donation_level[0]
        end
      end
      donations_data << Donation.new(project_id: self.id, amount: user[1], user_id: user[0], perk_name: levels.first, last_founded: user[2], anonymous: user[3])
    end

    donations_data
  end

  def group_and_sort_donor(data, project_id)
    data.group_by{ |p| p.perk_name  }.sort_by{|key, value| get_amount_by_perk_name(key, project_id) }.reverse
  end

  def total_donation_by_user(data)
    data.map { |donation| donation.amount }.inject(0) {|sum, element| sum + element }
  end

  def last_donation_by_user(data)
    data.sort_by { |founder| founder.updated_at }.last.updated_at.strftime("%m/%d")
  end

  def get_amount_by_perk_name(perk_name, project_id)
    perk = Perk.where(name: perk_name, project_id: project_id)
    if perk.empty?
      0
    else
      perk.first.amount
    end
  end

  def list_recepient
    data = []
    level_ids = self.project_sponsors.map(&:level_id).uniq.sort{ |x,y| y <=> x }
    perk_names = self.donations.where(anonymous: false).map(&:perk_name).uniq
    sponsorship_levels = SponsorshipLevel.where("id IN (?)", level_ids).uniq

    data.push(["All Project Sponsors","All Project Sponsors", {"data-name" => "All Project Sponsors"}]) unless sponsorship_levels.empty?
    sponsorship_levels.map { |sponsor| [sponsor.name + " Level Sponsors", sponsor.id, {"data-name" => sponsor.name + " Level Sponsors"}] }.each { |sponsor| data << sponsor }
    data.push(["All Project Donors","All Project Donors", {"data-name" => "All Project Donors"}]) unless perk_names.empty?
    perk_names.map { |sponsor| [sponsor + " Project Donors" , sponsor + " Project Donors", {"data-name" => sponsor + " Project Donors"} ] }.each { |sponsor| data << sponsor }
    if !sponsorship_levels.empty? and !perk_names.empty?
      data.unshift(["All Project Sponsors and Donors","All Project Sponsors and Donors", {"data-name" => "All Project Sponsors and Donors"}])
    end
    data.unshift(["My Contacts", "My Contacts"])
    data
  end

  def amount_per_day
    if self.donations.blank? and self.project_sponsors.blank?
      amount_by_date = ""
    else
      amount_by_date = []
      self.created_at.to_date.upto(Time.now.to_date).each do |date|
        amount = 0
        amount += self.donations.where("updated_at > ? AND updated_at < ?", date.at_beginning_of_day, date.end_of_day).sum(:amount)
        amount += self.project_sponsors.where("updated_at > ? AND updated_at < ?", date.at_beginning_of_day, date.end_of_day).sum(:cost)
        amount += amount_by_date.last unless amount_by_date.empty?
        amount_by_date << amount
      end
    end

    amount_by_date
  end

  def project_sponsor_by_level(page_num)
    data = self.project_sponsors.group_by { |sponsor| sponsor.level_id }.sort.map{ |sponsor| sponsor[1] }.flatten
    Kaminari.paginate_array(data).page(page_num).per(25)
  end

  def print_test
    logger.debug("Test Crap")
  end

  def founders(page_num)
    total_data = populate_funding_by_project.sort {|x,y| y.created_at <=> x.created_at }
    Kaminari.paginate_array(total_data).page(page_num).per(25)
  end

  def all_funding_by_project(page_num)
    total_data = populate_funding_by_project.group_by{ |p| p.updated_at.to_date  }.sort {|x,y| y <=> x }
    Kaminari.paginate_array(total_data).page(page_num).per(25)
  end

  def total_funding_by_project
    total_amout, individual_amount, business_amount, family_amount, foundation_amount = 0, 0, 0, 0, 0

    populate_funding_by_project.each do |funding|
      if funding.type_founder.eql?("individual")
        individual_amount += funding.amount.to_i
        total_amout += funding.amount.to_i
      else
        if funding.sponsor_type.eql?("Foundation")
          foundation_amount += funding.cost.to_i
        elsif funding.sponsor_type.eql?("Business")
          business_amount += funding.cost.to_i
        else
          family_amount += funding.cost.to_i
        end
        total_amout += funding.cost.to_i
      end
    end

    fundings_data = {
      total_amount: total_amout,
      individual_amount: individual_amount,
      business_amount: business_amount,
      family_amount: family_amount,
      foundation_amount: foundation_amount
    }
    fundings_data
  end

  def populate_funding_by_project
    fundings = []
    self.donations.each do |sponsor|
      sponsor.type_founder = "individual"
      fundings << sponsor
    end unless self.donations.empty?

    self.project_sponsors.each do |sponsor|
      sponsor.type_founder = "sponsor"
      fundings << sponsor
    end unless self.project_sponsors.empty?
    fundings
  end

  def self.send_confirmation_email(project)
    ProjectMailer.project_confirmation(project).deliver
  end

  def self.send_approval_email(project)
    ProjectMailer.project_approved(project).deliver
  end

  def downcase_city
    unless self.city.nil?
      self.city.downcase!
    end
  end

  def downcase_url_and_facebook
    self.twitter_handle.downcase! unless self.twitter_handle.nil?
    self.website.downcase! unless self.website.nil?
    self.facebook_page.downcase! unless self.facebook_page.nil?
  end

  def self.check_days_left
    today = DateTime.now
    projects = Project.where("live = ?", 1)
    projects.each do |p|
      if p.campaign_deadline.to_date == Date.today
        p.live=0
        p.save!
      end
    end
  end

  def get_donors(project)
    donors = Donation.where("project_id = ?", project.id)
  end

  def get_sponsors(project)
    sponsors = ProjectSponsor.where("project_id = ? AND customer_id != ?", project.id, '')
  end

  def create_token(customer_token, access_token)
    Stripe::Token.create(
      {:customer => customer_token},
      access_token
    )
  end

  def create_charges
    donors = get_donors(self)
    sponsors = get_sponsors(self)

    donors.each do |donor|
      token = create_token(donor.customer_token, self.project_token)
      amount = donor.amount.to_i * 100
      description = self.project_title
      application_fee = (amount * 0.06).to_i
      project_token = self.project_token

      Stripe::Charge.create({
          :amount => amount,
          :currency => "usd",
          :card => token.id,
          :description => description,
          :application_fee => application_fee
        },
        project_token
      )
    end

    sponsors.each do |sponsor|
      token = create_token(sponsor.customer_id, self.project_token)
      amount = sponsor.cost.to_i * 100
      description = self.project_title
      application_fee = (amount * 0.10).to_i
      project_token = self.project_token

      Stripe::Charge.create({
          :amount => amount,
          :currency => "usd",
          :card => token.id,
          :description => description,
          :application_fee => application_fee
        },
        project_token
      )
    end
  end

end
