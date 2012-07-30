class Project < ActiveRecord::Base
  attr_accessible :amount, :due_date, :name, :image
  
  # has_attached_file :image, 
  # 	:styles => { 
  # 		:large => "640x480>", 
  # 		:medium => "200x150>", 
  # 		:thumb => "100x100>" }

  has_attached_file :image,
     :storage => :s3,
     :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
     :s3_headers => {"Content-Disposition" => "attachment"},
     :styles => { 
		:large => "640x480>", 
		:medium => "200x150>", 
		:thumb => "100x100>" }
end
