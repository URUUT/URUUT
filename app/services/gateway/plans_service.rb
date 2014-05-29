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

  def addCoupon(coupon_id)
    @coupon = coupon_id
  end

  def validCoupon
    if @coupon
      begin
      coupon = Stripe::Coupon.retrieve(@coupon)
      return true if coupon.valid
      rescue => e
        user.errors.add(:coupon_stripe_token, "No such coupon #{@coupon}")
        Rails.logger.error e
        return false
      end
    end
    true
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
      response = update_or_create_basic_plus_subscription(plan)
      membership.stripe_subscription_id = response.id
      membership.save
    else
      false
    end
  end

  def update_or_create_basic_plus_subscription(plan)
    response = customer.subscriptions.all(limit: 1)
    user.update_attributes({coupon_stripe_token: @coupon})
    if response.count > 0
      response = response.data[0]
      response.plan = plan.name
      begin
        response.delete_discount
      rescue => e
        Rails.logger.error e
      end
    else
      response = customer.subscriptions.create(plan: plan.name)
    end
    response.coupon = @coupon if @coupon
    response.save
    response
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
