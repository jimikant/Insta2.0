# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.0'

# For Bullet_Prevent_(N+1)_Query
group :development do
  gem 'bullet'
end

# For Sending_notification_and_exceptions_to_my_slack_account
gem 'exception_notification'
gem 'slack-notifier'

# For Test_methodology
group :development, :test do
  # For TDD_Rspec
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails'
  # For FactoryBoot
  gem 'factory_bot_rails'
  # For assigns_method
  gem 'rails-controller-testing'

  # For BDD_Cucumber_rspec
  gem 'cucumber-rails', require: false
  gem 'database_cleaner-active_record'
end

# For stripe_payment
gem 'stripe', '~> 5.0'
gem 'stripe_event'

# For redis
gem 'redis-activesupport'
gem 'redis-rails'

# For sidekiq
gem 'sidekiq'

# For user_role_specification
gem 'cancancan', '~> 3.6.1'

# For pagination
gem 'kaminari'

# For friendly_id
gem 'friendly_id', '~> 5.4.0'

# For image_rocessing
gem 'image_processing', '>= 1.2'

# For gemfile_devise
gem 'devise'

# For image_clearity
gem 'mini_magick'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.1.3', '>= 7.1.3.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mswin mswin64 mingw x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # For Latter_opener
  gem 'letter_opener'
  gem 'letter_opener_web'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
end
