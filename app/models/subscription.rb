class Subscription < ActiveRecord::Base
  belongs_to :membership
  attr_accessible :stripe_plan_id

  def active?
    canceled_at.blank?
  end

  def canceled?
    !active?
  end

end
