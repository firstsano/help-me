class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [Question, Answer, Comment, Attachment]
    return unless user.present?

    can :read, :all
    can :comment, [Question, Answer]
    can :create, [Question, Answer, Comment, Attachment]
    can :update, [Question, Answer], created_by: user
    can :destroy, [Question, Answer], created_by: user
    can :upvote, [Question, Answer]
    cannot :upvote, [Question, Answer], created_by: user
    can :downvote, [Question, Answer]
    cannot :downvote, [Question, Answer], created_by: user
  end
end
