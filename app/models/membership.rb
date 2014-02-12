class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :sponsor
  belongs_to :plan

  def kind
    plan.name
  end

  def basic_or_plus?
    plan && ['basic', 'plus'].include?(kind)
  end

  def clean_plan_data!
    self.plan = nil
    self.stripe_subscription_id = nil
    save
  end
end
