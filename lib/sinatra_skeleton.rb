# frozen_string_literal: true

require 'yaml'
require 'socket'
require 'etc'
require 'mysql2'
require 'pg'
require 'redis'

module SinatraSkeleton

  # Return a Pathname object so we can use nice methods on it :
  # SinatraSkeleton.root.join('tmp', 'foo', 'bar.yml')
  def self.root
    Pathname.new root_dir
  end

  # Set the application root dir (the result is cached as it should not change)
  def self.root_dir
    @root_dir ||= File.realpath(File.dirname(File.expand_path('../config.ru', __dir__)))
  end

  # Do the require after methods defintions as
  # we may need them while defining app configuration
  require 'sinatra_skeleton/version'
  require 'sinatra_skeleton/settings'
  require 'sinatra_skeleton/config'
  require 'sinatra_skeleton/app'
end
