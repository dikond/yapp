$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'dotenv/load'

require 'pry-byebug' if ENV['RACK_ENV'] == 'development'

require_relative 'models'
