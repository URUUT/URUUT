class Project < ActiveRecord::Base
  attr_accessible :category, :description, :duration, :goal, :location, :title, :image, :video, :tags
  attr_writer :current_step

  belongs_to :user

  has_attached_file :image,
       :styles => {
       :thumb=> "100x100#",
       :small  => "230x230>" },
     :storage => :s3,
     :s3_credentials => "#{Rails.root}/config/s3.yml"

  # process_in_background :image

end
