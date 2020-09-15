class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, [Book]
    end
  end
end
