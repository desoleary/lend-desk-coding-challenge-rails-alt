require 'rails_helper'

describe LoginSessionCreateAction do
  let(:user_id) { 'email@domain.com' }
  let(:email) { 'email@domain.com' }
  let(:input) { { user_id: email } }
  let!(:user) { User.new(id: user_id, email: user_id).save }
  let(:ctx) do
    LightService::Testing::ContextFactory
      .make_from(LoginSessionCreateOrganizer)
      .for(described_class)
      .with(input)
  end

  subject { described_class.execute(ctx) }

  it 'creates session and returns login session state for secure cookie storage' do
    subject

    expect(subject.success?).to be_truthy
    expect(subject.keys).to include(:input, :errors, :params)
    expect(subject.errors).to be_empty

    expect(subject.params.keys).to match_array(%i[login_state user_id])
    expect(subject.params[:user_id]).to eql(email)

    login_state = subject.params[:login_state]
    expect(login_state.keys).to match_array([:user_id, :session_id, :initiated_at, :expires_at])
    expect(login_state[:user_id]).to eql(email)

    expiration_delta = login_state[:expires_at] - login_state[:initiated_at]
    expect(expiration_delta).to eql(2.hours.to_i)

    session = LoginSession.find(login_state[:session_id])
    expect(session).to be_present
  end

  context 'with unknown user_id' do
    let(:email) { 'unknown@domain.com'}

    it 'adds unknown email to errors' do
      subject

      expect(subject.failure?).to be_truthy

      errors = subject.errors
      expect(errors).to be_present
      expect(errors.keys).to eql([:user_id])
      expect(errors[:user_id]).to eql('not found')
    end
  end
end
