require 'swagger_helper'

describe 'Session API' do
  let(:user_email) { 'email@domain.com' }
  let(:user_password) { 'aA9^efgh' }
  let(:email) { 'email@domain.com' }
  let(:password) { 'aA9^efgh' }

  path '/users/sign_in' do
    let(:user_sign_in) { { email: email, password: password } }
    let!(:user) { UserCreateOrganizer.call({ email: user_email, password: user_password, password_confirmation: user_password }) }

    post 'Creates a user session' do
      tags 'User Sign In'
      consumes 'application/json; charset=UTF-8'
      parameter name: :user_sign_in, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }

      response '201', 'user session created' do
        run_test! do
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eql(user_id: email)

          secure_session = cookies[:secure_session]
          expect(secure_session).to be_present

          decrypted_secure_session = Encryptor.decrypt(secure_session)
          expect(decrypted_secure_session.keys).to match_array(%i[user_id session_id initiated_at expires_at last_request_at])

          expect(decrypted_secure_session[:user_id]).to eql(email)
          expect(decrypted_secure_session[:initiated_at]).to be_present
          expect(decrypted_secure_session[:expires_at]).to be_present
          expect(decrypted_secure_session[:last_request_at]).to be_present
          expect(decrypted_secure_session[:session_id]).to be_present

          login_session = LoginSession.find(decrypted_secure_session[:session_id])
          expect(login_session).to be_present
        end
      end

      response '401', 'unknown user email' do
        let(:email) { 'unknown@user.com' }

        run_test! do
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eql(errors: { email: 'not found' })

          secure_session = cookies[:secure_session]
          expect(secure_session).to be_nil
        end
      end

      response '401', 'unexpected password' do
        let(:password) { 'wrong-password' }

        run_test! do
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eql(errors: { email: 'invalid credentials' })

          secure_session = cookies[:secure_session]
          expect(secure_session).to be_nil
        end
      end

      response '500', 'handles unexpected error' do
        before(:each) { allow(UserAuthOrganizer).to receive(:call).and_raise(StandardError) }

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
