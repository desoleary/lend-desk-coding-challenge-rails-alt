# frozen_string_literal: true

require 'swagger_helper'

describe 'User API' do
  let(:email) { 'email@domain.com' }
  let(:password) { 'aA9^efgh' }
  let(:password_confirmation) { 'aA9^efgh' }

  path '/users/sign_up' do
    let(:user_sign_up) { { email: email, password: password, password_confirmation: password_confirmation } }

    post 'Creates a user' do
      tags 'User Sign Up'
      consumes 'application/json'
      parameter name: :user_sign_up, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string }
        },
        required: %w[email password password_confirmation]
      }

      response '201', 'user created' do
        run_test! do
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eql(user_id: email)

          secure_session = cookies[:secure_session]
          expect(secure_session).to be_present

          decrypted_secure_session = Encryptor.decrypt(secure_session)
          login_session = LoginSession.find(decrypted_secure_session[:session_id])
          expect(login_session).to be_present
        end
      end

      response '400', 'invalid email' do
        let(:email) { 'invalid-email.com' }

        run_test! do
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eql({ errors: { email: 'must be a valid email' } })

          secure_session = cookies[:secure_session]
          expect(secure_session).to be_nil
        end
      end

      response '400', 'invalid password' do
        let(:password) { 'insecure-password' }

        run_test! do
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eql({ errors: { password: 'must contain at least 1 number' } })

          secure_session = cookies[:secure_session]
          expect(secure_session).to be_nil
        end
      end

      response '400', 'unmatched password confirmation' do
        let(:password_confirmation) { 'unmatched-password' }

        run_test! do
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eql({ errors: { password: 'password must match password confirmation' } })

          secure_session = cookies[:secure_session]
          expect(secure_session).to be_nil
        end
      end

      response '500', 'handles unexpected error' do
        before(:each) { allow(UserCreateOrganizer).to receive(:call).and_raise(StandardError) }

        run_test! do
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eql({ errors: { error: 'internal server error' } })

          secure_session = cookies[:secure_session]
          expect(secure_session).to be_nil
        end
      end
    end
  end
end
