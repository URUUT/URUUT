class Video < ActiveRecord::Base
  attr_accessible :project_video
  belongs_to :project
  
  has_attached_file :project_video,
  		:styles => { 
	      :medium => { :geometry => "640x480", :format => 'flv' },
	      :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
	    }, 
     # :processors => [:ffmpeg],
     :storage => :s3,
     :s3_credentials => {:access_key_id => ENV['S3_KEY'], 
                         :secret_access_key => ENV['S3_SECRET'],
                     	   :bucket => 'venturebridge-dev'}

  process_in_background :project_video
end
