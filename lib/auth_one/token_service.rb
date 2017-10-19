# frozen_string_literal: true

require 'jwt'

module AuthOne
  class TokenService
    def initialize(private_key, **options)
      @private_key = private_key
      @public_key = private_key.public_key
      defaults = {
        algorithm: 'RS256',
        exp_leeway: AuthOne.configuration.token_exp_leeway,
        iss: AuthOne.configuration.token_iss,
        verify_iss: true,
        verify_iat: true
      }
      @options = defaults.merge(options)
    end

    def token_for(user)
      payload = { data: { email: user['email'] } }.merge(claims)
      JWT.encode(payload, @private_key, 'RS256')
    end

    def decode_token(token)
      JWT.decode(token, @public_key, true, @options)
    end

    private

    def claims
      exp = Time.now.to_i + AuthOne.configuration.token_exp
      iat = Time.now.to_i
      { exp: exp, iss: AuthOne.configuration.token_iss, iat: iat }
    end
  end
end
