# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AuthOne::App do
  def app
    AuthOne::App
  end

  describe 'POST /token' do
    context 'when the request body is not a json' do
      it 'fails with unauthorized' do
        post '/token', 'not_json', 'CONTENT_TYPE' => 'application/json'
        expect(last_response).to be_bad_request
      end
    end

    context 'when no user is given' do
      it 'fails with unauthorized' do
        post '/token', {}.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(last_response).to be_bad_request
      end
    end

    context 'when the user does not exist' do
      let(:unknown_user) { { email: 'pepe@pepe.com', password: 'fake' } }
      it 'fails with unauthorized' do
        post '/token', { user: unknown_user }.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(last_response).to be_unauthorized
      end
    end

    context 'when the user is correct' do
      let(:correct_user) { { email: 'pepe@pepe.com', password: 'fake' } }
      let(:private_key) { OpenSSL::PKey::RSA.generate 2048 }
      let(:token_iss) { 'My Company Inc.' }
      let(:password_hash) { BCrypt::Password.create(correct_user[:password]) }

      before do
        AuthOne.configure do |config|
          config.user_getter = proc do |_|
            OpenStruct.new(password_hash: password_hash)
          end
          config.private_key = private_key
          config.token_iss = token_iss
        end
      end

      it 'returns a valid token' do
        post '/token', { user: correct_user }.to_json, 'CONTENT_TYPE' => 'application/json'
        expect(last_response).to be_ok
        token_service = AuthOne::TokenService.new(private_key)
        token = JSON.parse(last_response.body)['token']
        expect { token_service.decode_token(token) }.not_to raise_error
      end
    end
  end
end
