# Set BUNDLE_GEMFILE to point to our Gemfile
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# Set up gems listed in the Gemfile (add them to Ruby LOAD_PATH)
require 'bundler/setup'

# Add our lib directory to the LOAD_PATH
$:.push File.expand_path('../lib', __dir__)
