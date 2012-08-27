class Project < ActiveRecord::Base
  attr_accessible :category, :description, :duration, :goal, :location, :title, :image, :video, :tags
  attr_writer :current_step

  belongs_to :user
  has_many :donations

  has_attached_file :image,
       :styles => {
       :thumb=> "230x180#",
       :small  => "230x180#" },
     :storage => :s3,
     :s3_credentials => "#{Rails.root}/config/s3.yml"

  process_in_background :image

end
