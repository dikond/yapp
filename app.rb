# frozen_string_literal: true

require 'roda'
require 'auth'

class Yapp < Roda
  # ----------------------------------------------------------
  # Plugins
  # ----------------------------------------------------------

  plugin :halt
  plugin :request_headers
  plugin :json, classes: [Array, Hash, String, Sequel::Model]
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
          r.post do
            run(Operations::Register) do |result|
              response.status = 201
              Auth.new.encode(result.value!)
            end
          end
        end

        r.is 'analyses' do
          authenticate_user

          # show all analyses scoped by user
          r.get do
            @user.analyses
          end

          # send the files for analysis
          r.post do
            run(Operations::Analyze, user: @user) do |result|
              response.status = 200
              result.value!
            end
          end
        end
      end
    end
  end

  # ----------------------------------------------------------
  # Helpers
  # ----------------------------------------------------------

  def authenticate_user
    auth = request.headers['Authorization']
    render_not_authorized if auth.nil?

    matched = auth.match(/\ABearer (.+)\z/)
    render_not_authorized if matched.nil?

    (@user = Auth.new.find_user_by_token(matched[1])) || render_not_authorized
  end

  def render_not_authorized
    request.halt 401, { 'WWW-Authenticate' => 'Bearer' }, 'Unauthorized'
  end

  def run(operation, **args)
    params = request.params.transform_keys(&:to_sym)
    result = operation.new.call(params.merge(args))

    if result.failure?
      response.status = 422
      result.failure
    else
      yield result
    end
  end
end
