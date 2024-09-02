# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user (not logged in)

    if user.admin?
      can :read, User
      can :destroy, User
      can :user_index, User
      can :new, User

      can :manage, Profile do |profile|
        profile.user == user
      end

      can :destroy, Post
      can :manage, Post do |post|
        post.user == user
      end

    else
      can :destroy, User do |user|
        user.user == user
      end

      can :manage, Profile do |profile|
        profile.user == user
      end

      # # All users can read posts
      can :read, Post

      # Users can manage their own posts
      can [:edit, :update, :destroy], Post do |post|
        post.user == user
      end

      user_subscription = user.current_subscription
      return unless user_subscription # Return if the user does not have an active subscription

      case user_subscription.product.name
      when '#Infinite Posts'
        can :create, Post
      when '#10 Posts'
        can [:new, :create], Post if user.posts.count < 10
      when '#5 Posts'
        can [:new, :create], Post if user.posts.count < 5
      when '#2 Posts'
        can [:new, :create], Post if user.posts.count < 2
      end
    end
  end
end
