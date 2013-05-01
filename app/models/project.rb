class Project < ActiveRecord::Base
  belongs_to :user

  attr_accessible :category, :description, :duration, :goal, :address, :project_title,
    :city, :state, :zip, :neighborhood, :title, :image, :video, :tags, :live, :short_description,
    :perks_attributes, :galleries_attributes, :status, :organization, :website, :twitter_handle, :facebook_page,
    :story, :about, :large_image, :seed_image, :cultivation_image, :ready_for_approval

  #validates :title, :short_description, :description, :presence => true, :if => :active?
  #validates :image, :address, :city, :state, :zip, :neighborhood, :duration, :goal, :presence => true, :if => :active_or_step1?

  has_many :donations, dependent: :destroy
  has_many :perks
  has_many :galleries
  has_many :project_sponsors
  has_many :sponsorship_levels
  has_many :sponsorship_benefits

  accepts_nested_attributes_for :perks, allow_destroy: true
  accepts_nested_attributes_for :galleries, allow_destroy: true

  scope :live, where("live = 1")

  has_attached_file :image
    #:styles => {
      #:thumb=> "100x100#",
      #:medium=> "280x124#" }
     #:storage => :file,
     #:s3_credentials => "#{Rails.root}/config/s3.yml",
     #:path => "/public/images/:id/:style/:filename"

  #process_in_background :image

  def self.get_sponsor_token
    if :current_user
      Stripe.api_key = API_KEY

    end
  end

  def printTest
    logger.debug("Test Crap")
  end

  def self.send_confirmation_email(project)
    ProjectMailer.project_confirmation(project).deliver
  end

end
