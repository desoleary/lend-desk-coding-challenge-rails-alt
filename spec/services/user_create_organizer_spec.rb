require 'rails_helper'

describe UserCreateOrganizer do
  let(:email) { 'email@domain.com' }
  let(:password) { 'aA9^efgh' }
  let(:password_confirmation) { 'aA9^efgh' }
  let(:input) { { email: email, password: password, password_confirmation: password_confirmation } }

  subject { described_class.call(input) }

  it 'persists user to redis' do
    subject

    expect(subject.keys).to include(:input, :errors, :params)
    expect(subject.errors).to be_empty
    expect(subject.params).to include(user_id: 'email@domain.com')

    user = User.find(subject.params[:user_id])
    expect(user).to be_present

    expect(user.email).to eql(email)
    expect(user.password.length).to eql(60)
    expect(user.password_confirmation.length).to eql(60)
  end

  context 'with invalid data' do
    let(:password_confirmation) { 'other-password' }

    it 'prevents storing entry to redis' do
      subject

      expect(subject.keys).to include(:input, :errors, :params)
      expect(subject.errors).to eql(password: "password must match password confirmation")
      expect(subject.params).to_not include(user_id: 'email@domain.com')

      user = User.find(subject.params[:user_id])
      expect(user).to be_nil
    end
  end
end
