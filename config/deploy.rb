# config valid only for current version of Capistrano
lock '3.9.1'

## Base
set :application, 'sinatra-skeleton'
set :repo_url,    'https://github.com/jbox-web/sinatra-skeleton.git'
set :deploy_to,   '/data/www/sinatra-skeleton'

## SSH
set :ssh_options, {
  keys:          [File.join(Dir.home, '.ssh', 'id_rsa')],
  forward_agent: true,
  auth_methods:  %w[publickey]
}

## RVM
set :rvm_ruby_version, '2.4.2'

## Bundler
set :bundle_flags, '--deployment'

## Rails
append :linked_dirs, 'log', 'tmp'

## Foreman
set :foreman_roles,       :app
set :foreman_init_system, 'systemd'
set :foreman_services,    %w[web]
set :foreman_export_path, "#{deploy_to}/.config/systemd/user"
set :foreman_options,     {
  template: "#{deploy_to}/.foreman/templates/systemd",
  root:     current_path,
  timeout:  30,
}

## Deployment steps
namespace :deploy do
  after  'deploy:check:linked_files',   'config:install'
  after  'deploy:check:linked_files',   'foreman:install'
  after  'deploy:published',            'bundler:clean'
  after  'deploy:finished',             'foreman:export'
  after  'deploy:finished',             'foreman:restart'
end
