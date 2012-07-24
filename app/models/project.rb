class Project < ActiveRecord::Base
  attr_accessible :amount, :due_date, :name, :image
  
  has_attached_file :image, 
  	:styles => { 
  		:large => "640x480>", 
  		:medium => "200x150>", 
  		:thumb => "100x100>" }
end
