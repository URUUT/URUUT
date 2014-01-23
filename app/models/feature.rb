class Feature < ActiveRecord::Base

  has_many :plan_features
  has_many :plans, through: :plan_features

  attr_accessible :description, :name
end
