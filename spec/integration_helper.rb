require 'rack/test'
require './app'

module IntegrationHelper
  def app
    Rack::Builder.new.run(Yapp.freeze.app)
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :integration
  config.include IntegrationHelper,   type: :integration
end

require_relative 'documentation_helper'
