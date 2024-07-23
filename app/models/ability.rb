class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user (not logged in)

    if user.admin?
      can :manage, User
      can :manage, Profile do |profile|
        profile.user == user
      end
      can :manage, Post do |post|
        post.user == user
      end
    else
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
        if user.posts.count < 10
          can [:new, :create], Post
        end
      when '#5 Posts'
        if user.posts.count < 5
          can [:new, :create], Post
        end
      when '#2 posts'
        if user.posts.count < 2
          can [:new, :create], Post
        end
      end
    end
  end
end
