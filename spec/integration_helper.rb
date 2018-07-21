require 'rack/test'
require './app'

module IntegrationHelper
  def app
    Rack::Builder.new.run(Yapp.freeze.app)
  end

  def do_request_with_headers(headers = {})
    example.metadata[:headers] ||= {}
    example.metadata[:headers].merge!(headers)
    do_request
  end

  def do_auth_request(token:)
    do_request_with_headers('Authorization' => "Bearer #{token}")
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :integration
  config.include IntegrationHelper,   type: :integration

  config.around :each do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

require_relative 'documentation_helper'
