class Project < ActiveRecord::Base
  attr_accessible :category, :description, :duration, :goal, :address, 
    :city, :state, :zip, :neighborhood, :title, :image, :video, :tags, :live

  belongs_to :user
  has_many :donations, :dependent => :destroy

  # accepts_nested_attributes_for :objectives, :allow_destroy => true

  has_attached_file :image,
       :styles => {
         :thumb=> "100x100#" },
     :storage => :s3,
     :s3_credentials => "#{Rails.root}/config/s3.yml",
     :path => "/:id/:style/:filename"

  process_in_background :image

end
