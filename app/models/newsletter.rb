class Newsletter < ActiveRecord::Base
  attr_accessible :email

  validates :email, :email_format => { :message => "Invalid email" }
  validates :email, :uniqueness => { :case_sensitive => false }

end
