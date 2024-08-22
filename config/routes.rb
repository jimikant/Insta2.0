# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  # For webhooks
  post 'webhooks/stripe', to: 'webhooks#stripe'

  # For subscriptions
  resources :subscriptions, only: :index
  post 'subscriptions/:stripe_product_id', to: 'subscriptions#create', as: 'subscription_create'
  delete 'subscriptions/:stripe_subscription_id', to: 'subscriptions#destroy', as: 'destroy_subscription'

  # Secure Sidekiq Web UI with basic authentication
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  root 'users#index'

  get '/user_index', to: 'users#user_index', as: 'user_index'

  # Users Routes
  get '/user/new', to: 'users#new', as: 'new_user'
  get '/dashboard', to: 'users#dashboard', as: 'dashboard'
  get '/users/:id', to: 'users#show', as: 'user'
  post '/user', to: 'users#create', as: 'users'
  get '/users/:id/edit', to: 'users#edit', as: 'edit_user'
  patch '/users/:id', to: 'users#update', as: 'update_user'
  delete '/users/:id', to: 'users#destroy', as: 'destroy_user'
  get '/dashboard/settings', to: 'users#settings', as: 'settings_user'

  # For Letter_opener
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # Profiles Routes
  get '/dashboard/profile/new', to: 'profiles#new', as: 'new_profile'
  get '/dashboard/profile', to: 'profiles#show', as: 'profile'
  post '/dashboard/profile', to: 'profiles#create', as: 'profiles'
  get '/dashboard/profile/edit', to: 'profiles#edit', as: 'edit_profile'
  patch '/dashboard/profile', to: 'profiles#update', as: 'update_profile'
  delete '/dashboard/profile', to: 'profiles#destroy', as: 'destroy_profile'

  # Delete Profile_Avtar Routes
  delete '/dashboard/profile/avtar', to: 'profiles#delete_avtar', as: 'delete_avtar'

  # Posts Routes
  get '/dashboard/posts/new', to: 'posts#new', as: 'new_post'
  get '/dashboard/posts/:id', to: 'posts#show', as: 'post'
  post '/dashboard/posts', to: 'posts#create', as: 'posts'
  get '/dashboard/posts/:id/edit', to: 'posts#edit', as: 'edit_post'
  patch '/dashboard/posts/:id', to: 'posts#update', as: 'update_post'
  delete '/dashboard/posts/:id', to: 'posts#destroy', as: 'destroy_post'

  # Tags Routes
  get '/dashboard/tags', to: 'tags#index'
  get '/dashboard/tags/new', to: 'tags#new', as: 'new_tag'
  get '/dashboard/tags/:id', to: 'tags#show', as: 'tag'
  post '/dashboard/tags', to: 'tags#create', as: 'tags'
  get '/dashboard/tags/:id/edit', to: 'tags#edit', as: 'edit_tag'
  patch '/dashboard/tags/:id', to: 'tags#update', as: 'update_tag'
  delete '/dashboard/tags/:id', to: 'tags#destroy', as: 'destroy_tag'

  # Likes Routes
  post '/dashboard/likes', to: 'likes#create', as: 'likes'
  delete '/dashboard/likes/:id', to: 'likes#destroy', as: 'destroy_like'
end
