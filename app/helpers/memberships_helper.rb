module MembershipsHelper

  def membership_title(user)
    user.membership.kind.titlecase
  end

  def next_membership_renewal_date(user)
    (user.membership.updated_at + 1.month).strftime('%m-%d-%Y')
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

  def membership_cost_message_start(user)
    case user.membership.kind
    when 'fee'
      'subscription means you will be charged'
    when 'basic', 'plus'
      "subscription will be automatically renewed #{next_membership_renewal_date(user)} and charged"
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

end