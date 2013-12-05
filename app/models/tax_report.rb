class TaxReport < ActiveRecord::Base
  attr_accessible :url, :user_id, :project_id

  validates_presence_of :url,
  						uniqueness: true

  belongs_to :user
  belongs_to :project
end
