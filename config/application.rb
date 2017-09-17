# Load application dependencies in Ruby LOAD_PATH
require_relative 'boot'

# require gems listed in Gemfile
Bundler.require(:default)

# Load environment variables
require 'dotenv/load'

# Load settings from Figaro config file as environment variables
require 'figaro/sinatra_app'
Figaro.adapter = Figaro::SinatraApp
Figaro.load

# require our lib
require 'sinatra_skeleton'
