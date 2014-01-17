class TaxReport < ActiveRecord::Base
  attr_accessible :url, :user_id, :project_id

  validates_uniqueness_of :url, :scope => [:project_id]

  belongs_to :user
  belongs_to :project
end
