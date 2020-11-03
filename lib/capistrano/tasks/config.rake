# frozen_string_literal: true

namespace :config do

  def syslog_services
    fetch(:deploy_config, {})[:syslog_services] || []
  end

  def configure_services
    fetch(:deploy_config, {})[:configure_services] || []
  end

  desc 'Install configuration files'
  task install: [:generate] do
    configure_services.each do |template|
      Rake::Task["config:#{template}:install"].invoke
    end
  end

  desc 'Generate configuration files'
  task :generate do
    # Invoke base tasks
    Rake::Task['config:app:generate'].invoke
    Rake::Task['config:bash:generate'].invoke

    # Invoke additional tasks
    configure_services.each do |template|
      Rake::Task["config:#{template}:generate"].invoke
    end
  end


  namespace :app do
    desc 'Install application config'
    task :generate do
      on roles(:all) do |_host|
        # Create config dir
        execute 'mkdir', '-p', "#{shared_path}/config"
        execute 'mkdir', '-p', "#{shared_path}/tmp/sockets"

        # Upload config file if exists
        config_file = "deploy/application.#{fetch(:stage)}.conf"

        if File.exist?(config_file)
          # Upload config file
          upload! config_file, "#{shared_path}/config/application.conf"
          execute :chmod, 640, "#{shared_path}/config/application.conf"

          # Create symlink
          execute :ln, '-nfs', "#{shared_path}/config/application.conf", "#{release_path}/.env"
        end
      end
    end
  end


  namespace :bash do
    desc 'Install bash files'
    task :generate do
      on roles(:all) do |_host|
        # Install bash profile with a fix for env vars and systemd
        template 'bash/profile', "#{deploy_to}/.profile", 0o644
      end

      on roles(:app) do |_host|
        # Create bin dir
        execute 'mkdir', '-p', "#{deploy_to}/bin"

        # Install wrapper script around systemd services
        services = fetch(:foreman_services, [])
        template 'bash/systemd_wrapper.sh', "#{deploy_to}/bin/#{fetch(:application)}", 0o755, locals: { services: services }
      end
    end
  end

end
