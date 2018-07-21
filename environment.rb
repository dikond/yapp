$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

env = ENV.fetch('RACK_ENV', 'development')

require 'dotenv'
Dotenv.load(".env.#{env}.local", '.env')

require 'pry-byebug' if env == 'development'

require_relative 'models'
