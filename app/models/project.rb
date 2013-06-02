class Project < ActiveRecord::Base
  belongs_to :user

  attr_accessible :category, :description, :duration, :goal, :address, :project_title, :sponsorship_permission,
    :city, :state, :zip, :neighborhood, :title, :image, :video, :tags, :live, :short_description, :perk_permission,
    :perks_attributes, :galleries_attributes, :status, :organization, :website, :twitter_handle, :facebook_page, :seed_video,
    :story, :about, :large_image, :seed_image, :cultivation_image, :ready_for_approval, :organization_type,
    :organization_classification, :cultivation_video, :campaign_deadline

  attr_accessor :sponsorship_permission
  #validates :title, :short_description, :description, :presence => true, :if => :active?
  #validates :image, :address, :city, :state, :zip, :neighborhood, :duration, :goal, :presence => true, :if => :active_or_step1?

  with_options dependent: :destroy do |project|
    project.has_many :donations
    project.has_many :perks
    project.has_many :galleries
    project.has_many :project_updates
  end

  has_many :project_sponsors
  has_many :sponsorship_levels
  has_many :sponsorship_benefits

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

  def amount_per_day
    donations = self.donations
    sponsors = self.project_sponsors
    fundings = []

    donations.each do |sponsor|
      sponsor.type_founder = "individual"
      fundings << sponsor
    end unless donations.empty?

    sponsors.each do |sponsor|
      sponsor.type_founder = "sponsor"
      fundings << sponsor
    end unless sponsors.empty?

    amount_by_date = []

    fundings.group_by{ |p| p.updated_at.to_date  }.each do |date, founders|
      individual_count, sponsors_count, amount = 0, 0, 0
      founders.each do |founder|
        if founder.type_founder.eql?("individual")
          amount += founder.amount.to_i
        else
          amount += founder.cost.to_i
        end
      end
      amount_by_date << amount
    end

    amount_by_date
  end

  def printTest
    logger.debug("Test Crap")
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
