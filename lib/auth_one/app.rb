require 'sinatra'
require 'sinatra/json'
require 'sequel'
require 'bcrypt'
require 'jwt'

require_relative 'token_service'

module AuthOne
  class App < Sinatra::Base
    set :logging, true

    def generate_private_key
      OpenSSL::PKey::RSA.generate 2048
    end

    helpers do
      def token_service
        @token_service ||= TokenService.new(AuthOne.configuration.private_key ||
                                            generate_private_key)
      end

      def request_payload
        @request_payload ||= JSON.parse(request.body.read)
      rescue JSON::ParserError
        render_bad_request
        halt
      end

      def render_unauthorized
        status 401
        json error: 'Incorrect password or missing user'
      end

      def render_bad_request
        status 400
        json_structure = {
          user: { email: 'user@example.com', password: 'a_password' }
        }.to_json
        json error: 'The request body must be a json and have this structure: '\
                    "#{json_structure}"
      end
    end

    post '/token', provides: 'application/json' do
      email = request_payload.dig('user', 'email')
      return render_bad_request if email.nil?
      user = AuthOne.configuration.user_getter.call(email)
      return render_unauthorized if user.nil?
      user_password = BCrypt::Password.new(user.password_hash)
      incorrect_password = user_password != request_payload['user']['password']
      return render_unauthorized if incorrect_password
      json token: token_service.token_for(request_payload['user'])
    end
  end
end
