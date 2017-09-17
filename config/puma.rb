workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))
threads_count = Integer(ENV.fetch('MAX_THREADS', 5))
threads threads_count, threads_count

tag         'sinatra-skeleton'
rackup      DefaultRackup
environment ENV.fetch('RACK_ENV', 'development')

preload_app!

if ENV['RACK_ENV'] == 'production' || ENV['RACK_ENV'] == 'staging'
  if ENV['DOCKER'] == 'true'
    bind "tcp://#{ENV.fetch('LISTEN', '0.0.0.0')}:#{ENV.fetch('PORT', 5000)}"
  else
    bind "unix://#{File.join(Dir.pwd, 'tmp', 'sockets', 'puma.sock')}"
  end

  state_path           File.join(Dir.pwd, 'tmp', 'sockets', 'puma.state')
  activate_control_app "unix://#{File.join(Dir.pwd, 'tmp', 'sockets', 'pumactl.sock')}"
  stdout_redirect      File.join(Dir.pwd, 'log', 'puma.stdout.log'), File.join(Dir.pwd, 'log', 'puma.stderr.log')
else
  bind "tcp://#{ENV.fetch('LISTEN', '127.0.0.1')}:#{ENV.fetch('PORT', 5000)}"
end
