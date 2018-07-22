$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

env = ENV.fetch('RACK_ENV', 'development')
require 'pry-byebug' unless env == 'production'

require 'dotenv'
Dotenv.load(".env.#{env}.local", '.env')

require_relative 'shrine'
require_relative 'models'

Dir['./lib/operations/*.rb'].each { |f| require f }
