# frozen_string_literal: true

require 'jwt'

class Auth
  ALGORITHM = 'HS256'

  def initialize(secret: nil)
    @secret = secret || ENV.fetch('YAPP_AUTH_SECRET')
  end

  def encode(user)
    JWT.encode({ id: user.id }, @secret, ALGORITHM, { typ: 'JWT' })
  end

  def decode!(token)
    JWT.decode(token, @secret, true, { algorithm: ALGORITHM })
  end

  def find_user_by_token(token)
    payload, _ = decode!(token)
    User.find(payload['id'])
  rescue JWT::DecodeError
  end
end
