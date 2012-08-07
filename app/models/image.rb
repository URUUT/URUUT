class Image < ActiveRecord::Base
  
  belongs_to :project

  attr_accessible :image

  # has_attached_file :image,
  #      :styles => {
  #      :thumb=> "100x100#",
  #      :small  => "400x400>" },
  #    :storage => :s3,
  #    :s3_credentials => {:access_key_id => ENV['S3_KEY'], 
  #                        :secret_access_key => ENV['S3_SECRET'],
  #                    	 :bucket => 'venturebridge-dev'}

end
