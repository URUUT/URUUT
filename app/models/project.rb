class Project < ActiveRecord::Base
  attr_accessible :category, :description, :duration, :goal, :address, 
    :city, :state, :zip, :neighborhood, :title, :image, :video, :tags, :live, :short_description

  belongs_to :user
  has_many :donations, :dependent => :destroy

  #accepts_nested_attributes_for :objectives, :allow_destroy => true

  has_attached_file :image
    :styles => {
      :thumb=> "100x100#",
      :medium=> "280x124#" }
     :storage => :file,
     #:s3_credentials => "#{Rails.root}/config/s3.yml",
     :path => "/public/images/:id/:style/:filename"

  #process_in_background :image

end
