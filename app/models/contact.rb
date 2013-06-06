class Contact < ActiveRecord::Base
  belongs_to :user
  attr_accessible :email, :user_id
  attr_accessor :email_content, :header_photo, :email_recepient, :subject
end
