class Ability
  include CanCan::Ability

  def initialize user
    send("#{user.role}_abilities", user)
  end

  def admin_abilities _user
    can :manager, Book
  end

  def user_abilities _user
    can :read, Book
  end
end
