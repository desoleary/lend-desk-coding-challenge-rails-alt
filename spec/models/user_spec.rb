# frozen_string_literal: true

require 'rails_helper'

describe User do
  describe '.new' do
    it 'add redis entry' do
      user = User.new(id: 'desoleary@gmail.com')
      user.save

      actual = User.find('desoleary@gmail.com')
      expect(actual.attributes).to eql({ email: 'desoleary@gmail.com', password: '', password_confirmation: '' })
    end
  end

  describe '.create' do
    let(:email) { 'email@domain.com' }
    let(:password) { 'aA9^efgh' }
    let(:password_confirmation) { 'aA9^efgh' }

    it 'add redis entry' do
      User.create(email: email, password: password, password_confirmation: password_confirmation)

      user = User.find(email)
      expect(user.key).to eql("user:#{email}")
      expect(user.id).to eql(email)
      expect(user.email).to eql(email)

      encrypted_password = user.password
      expect(encrypted_password.length).to eql(60)

      encrypted_password_confirmation = user.password_confirmation
      expect(encrypted_password_confirmation.length).to eql(60)
    end
  end
end
