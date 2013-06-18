class Project < ActiveRecord::Base
  belongs_to :user

  attr_accessible :category, :description, :duration, :goal, :address, :project_title, :sponsorship_permission,
  :city, :state, :zip, :neighborhood, :title, :image, :video, :tags, :live, :short_description, :perk_permission,
  :perks_attributes, :galleries_attributes, :status, :organization, :website, :twitter_handle, :facebook_page, :seed_video,
  :story, :about, :large_image, :seed_image, :cultivation_image, :ready_for_approval, :organization_type,
  :organization_classification, :cultivation_video, :campaign_deadline, :sponsor_permission, :step

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

  def list_recepient
    data = []
    level_ids = self.project_sponsors.map(&:level_id).uniq
    perk_names = self.donations.map(&:perk_name).uniq
    sponsorship_levels = SponsorshipLevel.where("id IN (?)", level_ids).uniq

    sponsorship_levels.map { |sponsor| [sponsor.name, sponsor.id] }.each { |sponsor| data << sponsor }
    perk_names.map { |sponsor| [sponsor, sponsor] }.each { |sponsor| data << sponsor }
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
        amount_by_date << amount
      end
    end

    amount_by_date
  end

  def printTest
    logger.debug("Test Crap")
  end

  def founders(page_num)
    fundings = populate_funding_by_project
    total_data = fundings.sort {|x,y| y.created_at <=> x.created_at }

    Kaminari.paginate_array(total_data).page(page_num).per(25)
  end

  def all_funding_by_project(page_num)
    fundings = populate_funding_by_project
    total_data = []

    fundings.group_by{ |p| p.updated_at.to_date  }.sort {|x,y| y <=> x }.each { |funding| total_data << funding }
    Kaminari.paginate_array(total_data).page(page_num).per(25)
  end

  def founders(page_num)
    fundings = populate_funding_by_project
    total_data= fundings.sort {|x,y| x.created_at <=> y.created_at }
    Kaminari.paginate_array(total_data).page(page_num).per(25)
  end

  def total_funding_by_project
    fundings = populate_funding_by_project
    total_amout, individual_amount, business_amount, foundation_amount = 0, 0, 0, 0

    fundings.each do |funding|
      if funding.type_founder.eql?("individual")
        individual_amount += funding.amount.to_i
        total_amout += funding.amount.to_i
      else
        if funding.sponsor_type.eql?("Foundation")
          foundation_amount += funding.cost.to_i
        else
          business_amount += funding.cost.to_i
        end
        total_amout += funding.cost.to_i
      end
    end

    fundings_data = {
      total_amount: total_amout,
      individual_amount: individual_amount,
      business_amount: business_amount,
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

  def downcase_city
    unless self.city.nil?
      self.city.downcase!
    end
  end

end
