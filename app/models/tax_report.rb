class TaxReport < ActiveRecord::Base
  attr_accessible :url, :user_id

  validates_presence_of :url,
  						uniqueness: true

  belongs_to :user
end
