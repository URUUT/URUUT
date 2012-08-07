class Image < ActiveRecord::Base
  attr_accessible :project_image

  belongs_to :project

  has_attached_file :project_image,
       :styles => {
       :thumb=> "100x100#",
       :small  => "400x400>" },
     :storage => :s3,
     :s3_credentials => {:access_key_id => ENV['S3_KEY'], 
                         :secret_access_key => ENV['S3_SECRET'],
                     	 :bucket => 'venturebridge-dev'}

  process_in_background :project_image

end
