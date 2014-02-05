require 'stripe'

class Gateway::PlansService < Gateway::BaseService

  def update_plan(plan_id)
    return false unless find_card || plan_id == 'fee'

    plan = Plan.where(name: plan_id).first
    user_membership = @user.membership
    user_membership.plan = plan

    user_membership.save && update_subscription(plan_id)
  end

  def cancel_plan
    return false unless find_card

    customer.cancel_subscription
  end

private

  def update_subscription(plan_id)
    case plan_id
    when 'fee'
      true
    when 'basic', 'plus'
      customer.update_subscription(plan: plan_id)
    else
      false
    end
  end

end