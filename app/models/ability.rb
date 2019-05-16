class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, [Question, Answer, Comment, Attachment]
    return unless user.present?

    can :read, :all
    can :create, [Question, Answer, Comment, Attachment]
    can :update, [Question, Answer], created_by: user
    can :destroy, [Question, Answer], created_by: user
  end
end
