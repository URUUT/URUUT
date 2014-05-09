require 'stripe'
module MembershipsHelper

  def membership_title(user)
    user.membership.kind.titlecase
  end

  def next_membership_renewal_date(user)
    (user.membership.updated_at + 1.month).strftime('%m-%d-%Y')
  end

  def membership_expire_date(user)
    (user.membership.updated_at + 1.month - 1.day).strftime('%m-%d-%Y')
  end

  def membership_cost(user)
    case user.membership.kind
    when 'fee'
      '5% of any amount raised on each project'
    when 'basic'
      '$99 every 1 month'
    when 'plus'
      '$149 every 1 month'
    end
  end

  def membership_cost_by_plan(plan)
    case plan.name
    when 'fee'
      '5% of any amount raised on each project'
    when 'basic'
      '$99 every 1 month'
    when 'plus'
      '$149 every 1 month'
    end
  end

  def membership_cost_message_start(user)
    case user.membership.kind
    when 'fee'
      'means you will be charged'
    when 'basic', 'plus'
      "will be automatically renewed #{next_membership_renewal_date(user)} and charged"
    end
  end

  def membership_cost_message_end(user)
    case user.membership.kind
    when 'fee'
      'unless you change or cancel it.'
    when 'basic', 'plus'
      'unless you cancel your subscription before that time.'
    end
  end

  def membership_coupon_message(coupon_id)
    coupon = Stripe::Coupon.retrieve coupon_id
    "You applied a #{coupon.id} discount coupon to your membership"
  end

end