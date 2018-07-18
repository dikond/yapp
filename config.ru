require 'dotenv/load'
require_relative 'models'
require_relative 'app'

run Yapp.freeze.app
