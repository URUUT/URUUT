require 'stripe'

class Gateway::PlansService < Gateway::BaseService

  def update_plan(plan_id)
    membership = @user.membership
    cancel_plan if updates_from_basic_or_plus_to_fee?(membership, plan_id)
    update_stripe_subscription(membership, plan_id)
  end

  def cancel_plan
    membership = @user.membership
    if membership.basic_or_plus?
      return false unless find_card
    end

    cancel_stripe_subscription(membership)
    membership.clean_plan_data!
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
    plan_id == 'fee' && membership.basic_or_plus?
  end
end