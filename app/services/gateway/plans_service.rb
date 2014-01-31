require 'stripe'

class Gateway::PlansService < Gateway::BaseService

  def update_plan(plan_id)
    return false unless find_card

    plan = Plan.where(name: plan_id).first
    user_membership = @user.membership
    user_membership.plan = plan

    user_membership.save && customer.update_subscription(plan: plan_id)
  end

  def cancel_plan
    return false unless find_card

    customer.cancel_subscription
  end

end