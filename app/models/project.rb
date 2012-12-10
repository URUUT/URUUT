class Project < ActiveRecord::Base
  attr_accessible :category, :description, :duration, :goal, :address, 
    :city, :state, :zip, :neighborhood, :title, :image, :video, :tags, :live, :short_description, :perks_attributes

  belongs_to :user
  has_many :donations, :dependent => :destroy
  has_many :perks

  accepts_nested_attributes_for :perks, :allow_destroy => true
  #accepts_nested_attributes_for :objectives, :allow_destroy => true

  has_attached_file :image
    #:styles => {
      #:thumb=> "100x100#",
      #:medium=> "280x124#" }
     #:storage => :file,
     #:s3_credentials => "#{Rails.root}/config/s3.yml",
     #:path => "/public/images/:id/:style/:filename"

  #process_in_background :image
  
  def self.default_value
    x = '<h4>Short Summary</h4>'
    x += '<p>Contributors fund ideas they can be passionate about and to people they trust. 
          Here are some things to do in this section:</p>'
    x += '<ul><li>Introduce yourself and your background.</li>
          <li>Briefly describe your campaign and why it\'s important to you.</li>
          <li>Express the magnitude of what contributors will help you achieve.</li></ul>'
    x += 'Remember, keep it concise, yet personal. Ask yourself: 
          if someone stopped reading here would they be ready to make a contribution?<br /><br />'
    x += '<h4>Short Summary</h4>'
    x += '<p>Contributors fund ideas they can be passionate about and to people they trust. 
          Here are some things to do in this section:</p>'
    x += '<ul><li>Introduce yourself and your background.</li>
          <li>Briefly describe your campaign and why it\'s important to you.</li>
          <li>Express the magnitude of what contributors will help you achieve.</li></ul>'
    x += 'Remember, keep it concise, yet personal. Ask yourself: 
          if someone stopped reading here would they be ready to make a contribution?<br /><br />'
    x += '<h4>Short Summary</h4>'
    x += '<p>Contributors fund ideas they can be passionate about and to people they trust. 
          Here are some things to do in this section:</p>'
    x += '<ul><li>Introduce yourself and your background.</li>
          <li>Briefly describe your campaign and why it\'s important to you.</li>
          <li>Express the magnitude of what contributors will help you achieve.</li></ul>'
    x += 'Remember, keep it concise, yet personal. Ask yourself: 
          if someone stopped reading here would they be ready to make a contribution?<br /><br />'
    return x.html_safe
  end
end
