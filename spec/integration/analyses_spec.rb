require 'integration_helper'

RSpec.resource 'Api / V1 / Analyses', type: :integration do
  get '/api/v1/analyses' do
    example 'GET -> failure (unauthorized)' do
      do_request

      expect(status).to eq 401
      expect(response_body).to eq '"Unauthorized"'
    end
  end
end
