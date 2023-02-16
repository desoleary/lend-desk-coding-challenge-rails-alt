# frozen_string_literal: true

require 'rails_helper'

describe UserCreateAction do
  let(:email) { 'email@domain.com' }
  let(:password) { 'aA9^efgh' }
  let(:password_confirmation) { 'aA9^efgh' }
  let(:input) { { email: email, password: password, password_confirmation: password_confirmation } }
  let(:ctx) do
    LightService::Testing::ContextFactory
      .make_from(UserCreateOrganizer)
      .for(described_class)
      .with(input)
  end

  subject { described_class.execute(ctx) }

  it 'persists user to redis' do
    subject

    expect(subject.keys).to include(:input, :errors, :params)
    expect(subject.errors).to be_empty
    expect(subject.params).to include(user_id: 'email@domain.com')

    user = User.find(subject.params[:user_id])
    expect(user).to be_present

    expect(user.key).to eql("user:#{email}")
    expect(user.id).to eql(email)
    expect(user.email).to eql(email)

    encrypted_password = user.password
    expect(encrypted_password.length).to eql(60)

    encrypted_password_confirmation = user.password_confirmation
    expect(encrypted_password_confirmation.length).to eql(60)
  end

  context 'with invalid data' do
    let(:password_confirmation) { 'other-password' }

    it 'prevents storing entry to redis' do
      subject

      expect(subject.keys).to include(:input, :errors, :params)
      expect(subject.errors).to eql(password: 'password must match password confirmation')
      expect(subject.params).to_not include(user_id: 'email@domain.com')

      user = User.find(subject.params[:user_id])
      expect(user).to be_nil
    end
  end

  context 'with pre-existing user with email' do
    before(:each) do
      described_class.execute(ctx) # creates user with same email
    end

    it 'returns already exists error' do
      subject

      expect(subject.errors).to eql(email: 'already exists')
    end
  end
end
