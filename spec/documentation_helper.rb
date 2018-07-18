require 'rspec_api_documentation/dsl'
require './app'

RspecApiDocumentation.configure do |config|
  config.app = Yapp.freeze.app
  config.format = :html
end
