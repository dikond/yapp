require 'auth'
require 'models/user'

RSpec.describe Auth, type: :unit do
  let(:instance) { described_class.new(secret: 'windmill') }
  let(:user) { instance_double('user', id: 1) }

  describe '#encode' do
    subject { instance.encode(user) }

    it 'encodes user into JWT token' do
      is_expected.to eq 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MX0.iXj6mgH5hq7ZCk-tEJG1RhQabgjY1eHYQbsiyPe_K64'
    end
  end

  describe '#decode!' do
    subject(:result) { instance.decode!(token) }

    context 'with invalid token' do
      let(:token) { 'header.payload.signature' }

      it 'raises exception' do
        expect { result }.to raise_exception JWT::DecodeError
      end
    end

    context 'with valid token' do
      let(:token) { 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MX0.iXj6mgH5hq7ZCk-tEJG1RhQabgjY1eHYQbsiyPe_K64' }

      it 'returns payload and token headers' do
        is_expected.to eq [{ 'id' => 1 }, { 'alg' => 'HS256', 'typ' => 'JWT' }]
      end
    end
  end

  describe '#find_user_by_token' do
    subject { instance.find_user_by_token(token) }

    context 'with valid token' do
      let(:token) { instance.encode(user) }
      let(:user) { User.create(agent: 'mozilla') }

      it 'returns user instance' do
        is_expected.to eq user
      end
    end

    context 'with invalid token' do
      let(:token) { '12345' }

      it { is_expected.to be nil }
    end
  end
end
