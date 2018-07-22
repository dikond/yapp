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

  post '/api/v1/analyses' do
    parameter :url, required: true
    parameter :files, required: true

    # params
    let(:url) { 'https://www.w3.org/' }
    let(:files) { [html, js] }
    # seeds
    let(:token) { Auth.new.encode(user) }
    let(:user) { User.create(agent: 'moz') }
    let(:html) { Rack::Test::UploadedFile.new('./spec/fixtures/w3.html', 'text/html') }
    let(:js) { Rack::Test::UploadedFile.new('./spec/fixtures/w3.js', 'text/javascript') }

    context 'when no analysis was performed before' do
      example 'POST -> success' do
        expect { do_auth_request(token: token) }.to change { Analysis.count }.by(1)
        expect(status).to eq 200

        analysis = Analysis.last
        expect(analysis.status).to eq 'unsafe'
        expect(response_body).to eq analysis.to_json
      end
    end

    context 'when same analysis was performed before' do
      before do
        Analysis.create(
          url: url,
          status: 'undefined',
          checksum: '97a31d407e64689de6e9aabdcd7aa710'
        )
      end

      it 'returns previous results', document: false do
        analysis = Analysis.last

        expect { do_auth_request(token: token) }.not_to(change { Analysis.count })
        expect(status).to eq 200

        parsed_status = JSON.parse(response_body).fetch('status')
        expect(parsed_status).to eq 'undefined'
      end
    end
  end
end
