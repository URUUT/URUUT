class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role == "admin"
        can :manage, :all
    end
    if user.role == "pradmin"
        can :manage, PressCoverage
        can :manage, PressRelease
    end
  end
end
