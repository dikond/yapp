require 'integration_helper'
require 'auth'

RSpec.resource 'Api / V1 / Registration', type: :integration do
  post '/api/v1/registration' do
    parameter :agent, scope: :user, required: true

    context 'with valid params' do
      let(:agent) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:62.0) Gecko/20100101 Firefox/62.0' }

      example 'POST -> success' do
        explanation 'Returns unique JWT token'

        do_request

        expect(status).to eq 201
        expect(JSON.parse(response_body)).to match /\A[\w-]+(\.[\w-]+){2}\z/
      end
    end

    context 'with invalid params' do
      let(:agent) { '' }

      example 'POST -> failure' do
        explanation 'Returns errors'

        do_request

        expect(status).to eq 422
        expect(JSON.parse(response_body)).to eq('user' => { 'agent' => ['must be filled'] })
      end
    end
  end
end
