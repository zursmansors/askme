class Ability
  include CanCan::Ability

   attr_reader :user

  def initialize(user)
    @user = user
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :manage, [Question, Answer], user: user
    can :manage, Attachment, attachable: { user: user }
    can :set_best, Answer, question: { user: user }
    can :create,  [Question, Answer, Comment]
    can [:create, :destroy], Subscription, user: user

    alias_action :vote_up, :vote_down, :vote_reset, to: :vote
    can :vote, [Question, Answer]
    cannot :vote, [Question, Answer], user: user

    can :me, User, id: user.id

  end
end
