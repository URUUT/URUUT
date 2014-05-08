class Plan < ActiveRecord::Base
  has_many :membership
  has_many :plan_features
  has_many :features, through: :plan_features

  attr_accessible :stripe_plan_id, :name

  def has_feature?(feature_name)
    features.where(name: feature_name).exists?
  end
end
