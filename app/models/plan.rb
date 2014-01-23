class Plan < ActiveRecord::Base
  belongs_to :membership
  attr_accessible :stripe_plan_id


end
