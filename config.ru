require 'dotenv/load'

require 'pry-byebug' if ENV['RACK_ENV'] == 'development'

require_relative 'models'
require_relative 'app'

run Yapp.freeze.app
