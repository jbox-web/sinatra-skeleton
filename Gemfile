# frozen_string_literal: true

source 'https://rubygems.org'

# Server
gem 'puma'

# App Framework
gem 'sinatra'

# Configuration
gem 'dotenv'
gem 'figaro'
gem 'settingslogic'

# Foreman (so we can export systemd config files)
gem 'foreman'

group :development do
  # Deployment
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-foreman'
  gem 'capistrano-rvm'
  gem 'capistrano-template'

  gem 'rubocop'
end
