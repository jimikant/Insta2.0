# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  # describe "Sidekiq" do
  #   it "routes to Sidekiq web" do
  #     expect(get: "/sidekiq").to route_to(controller: "sidekiq/web", action: "index")
  #   end
  # end

  describe 'Webhooks Routes' do
    it 'routes to stripe webhook' do
      expect(post: '/webhooks/stripe').to route_to(controller: 'webhooks', action: 'stripe')
    end
  end

  describe 'Subscriptions Routes' do
    it 'routes to subscriptions index' do
      expect(get: '/subscriptions').to route_to(controller: 'subscriptions', action: 'index')
    end

    it 'routes to subscription create' do
      expect(post: '/subscriptions/stripe_product_id').to route_to(controller: 'subscriptions', action: 'create',
                                                                   stripe_product_id: 'stripe_product_id')
    end

    it 'routes to destroy subscription' do
      expect(delete: '/subscriptions/stripe_subscription_id').to route_to(controller: 'subscriptions',
                                                                          action: 'destroy', stripe_subscription_id: 'stripe_subscription_id')
    end
  end

  describe 'Root Route' do
    it 'routes to root path' do
      expect(get: '/').to route_to(controller: 'users', action: 'index')
    end
  end

  describe 'User Routes' do
    it 'routes to user index' do
      expect(get: '/user_index').to route_to(controller: 'users', action: 'user_index')
    end

    it 'routes to new user' do
      expect(get: '/user/new').to route_to(controller: 'users', action: 'new')
    end

    it 'routes to user dashboard' do
      expect(get: '/dashboard').to route_to(controller: 'users', action: 'dashboard')
    end

    it 'routes to user show' do
      expect(get: '/users/id').to route_to(controller: 'users', action: 'show', id: 'id')
    end

    it 'routes to create user' do
      expect(post: '/user').to route_to(controller: 'users', action: 'create')
    end

    it 'routes to edit user' do
      expect(get: '/users/id/edit').to route_to(controller: 'users', action: 'edit', id: 'id')
    end

    it 'routes to update user' do
      expect(patch: '/users/id').to route_to(controller: 'users', action: 'update', id: 'id')
    end

    it 'routes to destroy user' do
      expect(delete: '/users/id').to route_to(controller: 'users', action: 'destroy', id: 'id')
    end

    it 'routes to settings user' do
      expect(get: '/dashboard/settings').to route_to(controller: 'users', action: 'settings')
    end
  end

  # describe "Letter Opener" do
  #   it "routes to letter opener" do
  #     expect(get: "/letter_opener").to route_to(controller: "letter_opener_web", action: "index")
  #   end
  # end

  describe 'Profile Routes' do
    it 'routes to new profile' do
      expect(get: '/dashboard/profile/new').to route_to(controller: 'profiles', action: 'new')
    end

    it 'routes to show profile' do
      expect(get: '/dashboard/profile').to route_to(controller: 'profiles', action: 'show')
    end

    it 'routes to create profile' do
      expect(post: '/dashboard/profile').to route_to(controller: 'profiles', action: 'create')
    end

    it 'routes to edit profile' do
      expect(get: '/dashboard/profile/edit').to route_to(controller: 'profiles', action: 'edit')
    end

    it 'routes to update profile' do
      expect(patch: '/dashboard/profile').to route_to(controller: 'profiles', action: 'update')
    end

    it 'routes to destroy profile' do
      expect(delete: '/dashboard/profile').to route_to(controller: 'profiles', action: 'destroy')
    end

    it 'routes to delete avatar' do
      expect(delete: '/dashboard/profile/avtar').to route_to(controller: 'profiles', action: 'delete_avtar')
    end
  end

  describe 'Posts Routes' do
    it 'routes to new post' do
      expect(get: '/dashboard/posts/new').to route_to(controller: 'posts', action: 'new')
    end

    it 'routes to show post' do
      expect(get: '/dashboard/posts/1').to route_to(controller: 'posts', action: 'show', id: '1')
    end

    it 'routes to create post' do
      expect(post: '/dashboard/posts').to route_to(controller: 'posts', action: 'create')
    end

    it 'routes to edit post' do
      expect(get: '/dashboard/posts/1/edit').to route_to(controller: 'posts', action: 'edit', id: '1')
    end

    it 'routes to update post' do
      expect(patch: '/dashboard/posts/1').to route_to(controller: 'posts', action: 'update', id: '1')
    end

    it 'routes to destroy post' do
      expect(delete: '/dashboard/posts/1').to route_to(controller: 'posts', action: 'destroy', id: '1')
    end
  end

  describe 'Tags Routes' do
    it 'routes to tags index' do
      expect(get: '/dashboard/tags').to route_to(controller: 'tags', action: 'index')
    end

    it 'routes to new tag' do
      expect(get: '/dashboard/tags/new').to route_to(controller: 'tags', action: 'new')
    end

    it 'routes to show tag' do
      expect(get: '/dashboard/tags/1').to route_to(controller: 'tags', action: 'show', id: '1')
    end

    it 'routes to create tag' do
      expect(post: '/dashboard/tags').to route_to(controller: 'tags', action: 'create')
    end

    it 'routes to edit tag' do
      expect(get: '/dashboard/tags/1/edit').to route_to(controller: 'tags', action: 'edit', id: '1')
    end

    it 'routes to update tag' do
      expect(patch: '/dashboard/tags/1').to route_to(controller: 'tags', action: 'update', id: '1')
    end

    it 'routes to destroy tag' do
      expect(delete: '/dashboard/tags/1').to route_to(controller: 'tags', action: 'destroy', id: '1')
    end
  end

  describe 'Likes Routes' do
    it 'routes to create like' do
      expect(post: '/dashboard/likes').to route_to(controller: 'likes', action: 'create')
    end

    it 'routes to destroy like' do
      expect(delete: '/dashboard/likes/1').to route_to(controller: 'likes', action: 'destroy', id: '1')
    end
  end
end
