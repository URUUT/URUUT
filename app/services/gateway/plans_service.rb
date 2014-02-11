require 'stripe'

class Gateway::PlansService < Gateway::BaseService

  def update_plan(plan_id)
    membership = @user.membership
    cancel_plan if updates_from_basic_or_plus_to_fee?(membership, plan_id)
    update_stripe_subscription(membership, plan_id)
  end

  def cancel_plan
    membership = @user.membership
    return false unless find_card && membership.stripe_subscription_id

    cancel_stripe_subscription(membership)
    membership.plan = nil
    membership.stripe_subscription_id = nil
    membership.save
  end

private

  def update_stripe_subscription(membership, plan_id)
    plan = Plan.where(name: plan_id).first
    membership.plan = plan

    case plan_id
    when 'fee'
      membership.save
    when 'basic', 'plus'
      find_card
      response = customer.update_subscription(plan: plan_id)
      membership.stripe_subscription_id = response.id
      membership.save
    else
      false
    end
  end

  def cancel_stripe_subscription(membership)
    case membership.kind
    when 'basic', 'plus'
      customer.cancel_subscription
    end
  end

  def updates_from_basic_or_plus_to_fee?(membership, plan_id)
    plan_id == 'fee' && ['basic', 'plus'].include?(membership.kind)
  end
end