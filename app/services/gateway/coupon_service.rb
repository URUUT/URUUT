require 'stripe'

class Gateway::CouponService < Gateway::BaseService

  def initialize(user)
    super(user)
    find_customer
  end

  def create(coupon)
    return true if coupon.blank?
    retrieve(coupon)
    if @coupon
      begin
      customer.coupon = coupon
      customer.save

      user.update_attributes({ coupon_stripe_token: coupon })
      rescue => e
        Rails.logger.error e
        return false
      end
    end
  end

  def removeInvalid(plan_id)
    retrieve(user.coupon_stripe_token)
    if @coupon && ( !@coupon.valid || is_downgrade(plan_id) )
      customer.delete_discount
      user.update_attributes({ coupon_stripe_token: nil })
    end
  end

  private
  def retrieve(coupon)
    begin
    @coupon = Stripe::Coupon.retrieve(coupon)
    rescue => e
      user.errors.add(:coupon_stripe_token, "No such coupon #{coupon}")
      Rails.logger.error e
    end
  end

  def is_downgrade(plan_id)
    if (user.membership_kind == 'plus' && plan_id == 'basic') ||
       (user.membership_kind == 'basic' && plan_id == 'fee')
      return true
    end
    false
  end

end
