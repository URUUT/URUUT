class Project < ActiveRecord::Base
  attr_accessible :category, :description, :duration, :goal, :location, :title, :image, :video, :tags

  belongs_to :user
  has_many :donations, :dependent => :destroy

  # accepts_nested_attributes_for :objectives, :allow_destroy => true

  has_attached_file :image,
       :styles => {
       :thumb=> "230x180#",
       :small  => "230x180#" },
     :storage => :s3,
     :s3_credentials => "#{Rails.root}/config/s3.yml"

  process_in_background :image

end
