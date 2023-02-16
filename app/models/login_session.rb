# frozen_string_literal: true

class LoginSession < SimpleRedisOrm::ApplicationEntry
  EXPIRES_IN_SECONDS = 2.hours.to_i

  # authenticatable
  attribute :token, Types::String
  attribute :user_id, Types::String
  attribute :created_at, Types::String

  class << self
    def create(user_id:)
      session_token = SecureRandom.hex
      attrs = { token: session_token, user_id: user_id, created_at: Time.current.to_s }

      new(id: session_token, **attrs).save
    end
  end
end
