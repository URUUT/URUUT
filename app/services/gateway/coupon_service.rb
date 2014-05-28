require 'stripe'

class Gateway::CouponService < Gateway::BaseService

  def initialize(user)
    super(user)
    find_customer
  end

  def create(coupon)
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
    else
      return false unless coupon.blank?
      user.update_attributes({ coupon_stripe_token: nil })
    end
  end

  def removeInvalid(plan_id)
    retrieve(user.coupon_stripe_token)
    if @coupon && ( !@coupon.valid || is_downgrade(plan_id) )
      customer.coupon = nil
      customer.save
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
      false
    end
  end

  def is_downgrade(plan_id)
    if user.membership_kind == 'basic' && plan_id == 'plus' ||
       user.membership_kind == 'fee' && plan_id == 'basic'
      return true
    end
    false
  end

end
