class PlanFeature < ActiveRecord::Base
  belongs_to :plan
  belongs_to :feature
  # attr_accessible :title, :body
end
