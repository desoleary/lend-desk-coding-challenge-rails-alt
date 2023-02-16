# frozen_string_literal: true

require 'rails_helper'

describe ApplicationContract do
  describe 'Registered Macros' do
    describe ':email' do
      let(:contract_class) do
        Class.new(ApplicationContract) do
          params do
            required(:email).maybe(:string)
          end

          rule(:email).validate(:email)
        end
      end

      let(:email) { nil }
      let(:params) { { email: email } }

      subject { contract_class.new.call(params) }

      context 'with valid email' do
        let(:email) { 'email@domain.com' }

        it 'returns success' do
          expect(subject.success?).to be_truthy
        end
      end

      context 'with invalid email' do
        let(:email) { 'emaildomain.com' }

        it 'returns failure' do
          expect(subject.failure?).to be_truthy

          errors = subject.errors.to_h
          expect(errors.keys).to match_array([:email])

          error_messages = errors[:email]
          expect(error_messages).to match_array( ["must be a valid email"])
        end
      end
    end

    describe ':password' do
      let(:contract_class) do
        Class.new(ApplicationContract) do
          params do
            required(:password).maybe(:string)
          end

          rule(:password).validate(:password)
        end
      end

      let(:password) { nil }
      let(:params) { { password: password } }

      subject { contract_class.new.call(params) }

      context 'with valid password' do
        let(:password) { 'aA9^efgh' }

        it 'returns success' do
          expect(subject.success?).to be_truthy
        end
      end

      context 'with invalid password' do
        let(:password) { '' }

        it 'returns error messages' do
          expect(subject.success?).to be_falsey

          errors = subject.errors.to_h
          expect(errors.keys).to match_array([:password])

          error_messages = errors[:password]
          expect(error_messages).to match_array([
                                                  'must be at least 8 characters long',
                                                  'must contain at least 1 lowercase letter',
                                                  'must contain at least 1 number',
                                                  'must contain at least 1 symbols',
                                                  'must contain at least 1 uppercase letter'
                                                ])
        end
      end
    end
  end
end
