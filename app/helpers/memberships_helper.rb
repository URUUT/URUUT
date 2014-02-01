module MembershipsHelper

  def membership_title(user)
    user.membership.kind.titlecase
  end

  def next_membership_renewal_date(user)
    (user.membership.updated_at + 1.month).strftime('%d-%m-%Y')
  end

  def membership_cost(user)
    case user.membership.kind
    when 'fee'
      '5%'
    when 'basic'
      '$99'
    when 'plus'
      '$149'
    end
  end

end