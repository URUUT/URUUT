class Plan < ActiveRecord::Base
  belongs_to :membership

  has_many :plan_features
  has_many :features, through: :plan_features

  attr_accessible :stripe_plan_id


end
