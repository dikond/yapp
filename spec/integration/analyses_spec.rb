require 'integration_helper'
require 'auth'

RSpec.resource 'Api / V1 / Analyses', type: :integration do
  get '/api/v1/analyses' do
    context 'when no token provided' do
      example 'GET -> failure (unauthorized)' do
        do_request

        expect(status).to eq 401
        expect(response_body).to eq '"Unauthorized"'
      end
    end

    context 'when invalid token provided' do
      it 'returns 401 "Unauthorized"', document: false do
        do_auth_request(token: '12345')

        expect(status).to eq 401
        expect(response_body).to eq '"Unauthorized"'
      end
    end

    context 'when valid token provided' do
      let(:token) { Auth.new.encode(user) }
      let(:user) { User.create(agent: 'moz') }
      let(:google) { Analysis.create(url: 'http://google.com.ua', status: 'safe', checksum: '42') }
      let(:prekrasnoe) {
        Analysis.create(url: 'http://prekrasnoe.it', status: 'unsafe', checksum: '666')
      }

      before do
        user.add_analysis(google)
        user.add_analysis(prekrasnoe)
      end

      example 'GET -> success' do
        do_auth_request(token: token)

        expect(status).to eq 200
        expect(response_body).to eq user.analyses.to_json
      end
    end
  end
end
