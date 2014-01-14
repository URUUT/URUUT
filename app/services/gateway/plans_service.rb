require 'stripe'

class Gateway::PlansService < Gateway::BaseService

  def update_plan(plan_id)
    return false unless find_card

    customer.update_subscription(plan: plan_id)
  end

  def cancel_plan
    return false unless find_card

    customer.cancel_subscription
  end

end