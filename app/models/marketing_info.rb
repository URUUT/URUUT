class MarketingInfo < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name

  belongs_to :user

  validates :email, :first_name, :last_name, presence: true
  validates_uniqueness_of :email, case_sensitive: false

end
