# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user (not logged in)

    if user.admin?
      can :read, User
      can :destroy, User
      can :user_index, User
      # can :manage, User, id: user.id

      can :manage, Profile, id: user.id

      can :manage, Post, id: user.id

    else
      can :manage, Profile, id: user.id

      # # All users can read posts
      can :read, Post

      # Users can manage their own posts
      can [:edit, :update, :destroy], Post, id: user.id

      user_subscription = user.current_subscription
      return unless user_subscription # Return if the user does not have an active subscription

      case user_subscription.product.name
      when '#Infinite Posts'
        can :create, Post
      when '#10 Posts'
        can %i[new create], Post if user.posts.count < 10
      when '#5 Posts'
        can %i[new create], Post if user.posts.count < 5
      when '#2 Posts'
        can %i[new create], Post if user.posts.count < 2
      end
    end
  end
end
