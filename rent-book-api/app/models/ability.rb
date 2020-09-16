class Ability
  include CanCan::Ability

  def initialize user
    send("#{user.role}_abilities", user)
  end

  def admin_abilities _user
    can :manager, Book
  end

  def user_abilities user
    can :read, Book
    can [:read, :create], Comment
    can [:update, :destroy], Comment, user_id: user.id
  end
end
