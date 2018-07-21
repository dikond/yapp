# frozen_string_literal: true

require 'roda'
require 'auth'

class Yapp < Roda
  # ----------------------------------------------------------
  # Plugins
  # ----------------------------------------------------------

  plugin :halt
  plugin :request_headers
  plugin :default_headers,
    'Content-Type'=>'application/json',
    'X-Frame-Options'=>'deny',
    'X-Content-Type-Options'=>'nosniff',
    'X-XSS-Protection'=>'1; mode=block'

  # ----------------------------------------------------------
  # Routing tree
  # ----------------------------------------------------------

  route do |r|
    r.on 'api' do
      r.on 'v1' do
        r.is 'registration' do
          # generate uuid and store client metrics
          r.post do
          end
        end

        r.is 'analyses' do
          render_not_authorized(r) unless authenticate_user(r)

          # show all analyses scoped by user
          r.get do
            response.write @user.to_json
          end

          # send the files for analysis
          r.post do
          end
        end
      end
    end
  end

  # ----------------------------------------------------------
  # Helpers
  # ----------------------------------------------------------

  def authenticate_user(request)
    auth = request.headers['Authorization']
    return if auth.nil?

    matched = auth.match(/\ABearer (.+)\z/)
    return if matched.nil?

    @user = Auth.find_user_by_token(matched[1])
  end

  def render_not_authorized(request)
    request.halt 401, { 'WWW-Authenticate' => 'Token' }, '"Unauthorized"'
  end
end
