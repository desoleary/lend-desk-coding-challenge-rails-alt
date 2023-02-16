require 'rails_helper'

describe UserAuthAction do
  let(:user_email) { 'email@domain.com' }
  let(:user_password) { 'aA9^efgh' }
  let(:email) { 'email@domain.com' }
  let(:password) { 'aA9^efgh' }
  let!(:user) { User.create(email: user_email, password: user_password, password_confirmation: user_password) }

  let(:input) { { email: email, password: password } }
  let(:ctx) do
    LightService::Testing::ContextFactory
      .make_from(UserAuthOrganizer)
      .for(UserAuthAction)
      .with(input)
  end

  subject { described_class.execute(ctx) }

  it 'authenticates user' do
    expect(subject.keys).to include(:input, :errors, :params)
    expect(subject.params).to include(user_id: email)
    expect(subject.success?).to be_truthy

    user = User.find(subject.params[:user_id])
    expect(user).to be_present
  end

  context 'with unexpected email' do
    let(:email) { 'unknown_email@domain.com' }

    it 'returns email not found error message' do
      expect(subject.keys).to include(:input, :errors, :params)
      expect(subject.params).to include(user_id: nil)
      expect(subject.failure?).to be_truthy
      expect(subject.errors).to eql({ email: 'not found' })
    end
  end

  context 'with unexpected password' do
    let(:password) { 'other-password' }

    it 'returns email not found error message' do
      expect(subject.keys).to include(:input, :errors, :params)
      expect(subject.params).to include(user_id: email)
      expect(subject.failure?).to be_truthy
      expect(subject.errors).to eql({ email: 'invalid credentials' })
    end
  end
end
