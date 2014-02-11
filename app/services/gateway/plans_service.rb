require 'stripe'

class Gateway::PlansService < Gateway::BaseService

  def update_plan(plan_id)
    plan = Plan.where(name: plan_id).first
    user_membership = @user.membership
    user_membership.plan = plan

    update_stripe_subscription(user_membership, plan_id)
  end

  def cancel_plan
    return false unless find_card

    customer.cancel_subscription
  end

private

  def update_stripe_subscription(user_membership, plan_id)
    case plan_id
    when 'fee'
      true
    when 'basic', 'plus'
      find_card
      response = customer.update_subscription(plan: plan_id)
      user_membership.stripe_subscription_id = response.id
      user_membership.save
    else
      false
    end
  end

end