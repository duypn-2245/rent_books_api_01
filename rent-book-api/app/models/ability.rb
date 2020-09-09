class Ability
  include CanCan::Ability

  def initialize user
    send("#{user.role}_abilities", user)
  end

  def admin_abilities _user
    can :manage, Book
    can :update, RegisterBook
  end

  def user_abilities user
    can :read, Book
    can [:read, :create], Comment
    can [:update, :destroy], Comment, user_id: user.id
    can :create, RegisterBook
    can [:read, :update], RegisterBook, user_id: user.id
  end
end
