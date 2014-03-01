ActiveAdmin.register Membership do
  menu :label => "Customers"

  actions :all, :except => [:destroy]

  index do
    column :id
    column :name do |membership|
      "#{membership.user.first_name.capitalize} #{membership.user.last_name.capitalize}"
    end
    column :organization do |membership|
      membership.user.organization.capitalize if membership.user.organization
    end
    column :plan do |membership|
      membership.plan.name.capitalize
    end
    column :email do |membership|
      link_to membership.user.email, "mailto:#{membership.user.email}"
    end
    column :signed_up do |membership|
      membership.created_at.strftime("%d %b %Y at %I:%M %p")
    end
  end

  scope :fee do |memberships|
    memberships.joins(:plan).where(:plans => {:name => 'fee'})
  end

  scope :basic do |memberships|
    memberships.joins(:plan).where(:plans => {:name => 'basic'})
  end

  scope :plus do |memberships|
    memberships.joins(:plan).where(:plans => {:name => 'plus'})
  end

end
