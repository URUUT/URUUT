class Project < ActiveRecord::Base
  attr_accessible :category, :description, :duration, :goal, :location, :title, :images_attributes, :videos_attributes

  has_many :images
  has_many :videos

  accepts_nested_attributes_for :images
  accepts_nested_attributes_for :videos
  # mount_uploader :image, ImageUploader
  # mount_uploader :video, VideoUploader

  # has_attached_file :project_image,
  #      :styles => {
  #      :thumb=> "100x100#",
  #      :small  => "400x400>" },
  #    :storage => :s3,
  #    :s3_credentials => {:access_key_id => ENV['S3_KEY'], 
  #                        :secret_access_key => ENV['S3_SECRET'],
  #                    	   :bucket => 'venturebridge-dev'}

  # has_attached_file :project_video,
  # 		:styles => { 
	 #      :medium => { :geometry => "640x480", :format => 'flv' },
	 #      :thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10 }
	 #    }, :processors => [:ffmpeg],
  #    :storage => :s3,
  #    :s3_credentials => {:access_key_id => ENV['S3_KEY'], 
  #                        :secret_access_key => ENV['S3_SECRET'],
  #                    	   :bucket => 'venturebridge-dev'}

  # process_in_background :project_image
  # process_in_background :project_video


end
