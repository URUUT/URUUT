class MarketingInfo < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :href
  attr_accessor :href

  belongs_to :user

  validates :email, :first_name, :last_name, presence: true

end
