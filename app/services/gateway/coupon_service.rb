require 'stripe'

class Gateway::CouponService < Gateway::BaseService

  def create(coupon)
    return true if coupon.blank?
    return false unless retrieve(coupon)
    begin
    find_customer
    customer.coupon = coupon
    customer.save

    user.coupon_stripe_token = coupon
    user.save
    rescue => e
      Rails.logger.error e
    end
  end

  private
  def retrieve(coupon)
    begin
    Stripe::Coupon.retrieve(coupon)
    rescue => e
      user.errors.add(:coupon_stripe_token, "No such coupon #{coupon}")
      Rails.logger.error e
      false
    end
  end

end
