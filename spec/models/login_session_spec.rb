require 'rails_helper'

describe LoginSession do
  let(:user_id) { 'email@domain.com' }

  subject { described_class.create(user_id: user_id) }

  describe '.create' do
    it 'stores entry with session info as an encrypted token' do
      subject

      session = LoginSession.find(subject.token)

      expect(session).to be_present
      expect(session.id).to eql(session.token)
      expect(session.key).to eql("login_session:#{session.token}")
      expect(session.created_at).to be_present
    end
  end
end
