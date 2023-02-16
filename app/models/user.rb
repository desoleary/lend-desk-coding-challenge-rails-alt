# frozen_string_literal: true

class User < SimpleRedisOrm::ApplicationEntry
  # authenticatable
  attribute :email, Types::String.optional
  attribute :password, Types::String.optional
  attribute :password_confirmation, Types::String.optional

  class << self
    def new(id:, **attributes)
      super(id: id, **attributes.merge(email: without_redis_key_prefix(id)))
    end

    def create(email:, password:, password_confirmation:)
      attrs = { email: email,
                password: PasswordEncryptor.encrypt(password),
                password_confirmation: PasswordEncryptor.encrypt(password_confirmation) }

      new(id: email, **attrs).save
    end
  end
end
