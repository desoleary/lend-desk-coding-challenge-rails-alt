# frozen_string_literal: true

module Encryptor
  extend ActiveSupport::Concern

  NON_PROD_ENCRYPTOR_KEY = '97ab5c6752be72cad8cf39275cc83cab'

  class << self
    def encrypt(value)
      message_encryptor.encrypt_and_sign(value)
    end

    def decrypt(value)
      message_encryptor.decrypt_and_verify(value)
    end

    private

    def message_encryptor
      @message_encryptor ||= ActiveSupport::MessageEncryptor.new(message_encryptor_key)
    end

    def message_encryptor_key
      @message_encryptor_key ||= begin
                                   env_encryptor_key = ENV['MESSAGE_ENCRYPTOR_KEY']
                                   non_production_like = Rails.env.test? || Rails.env.development?

                                   return env_encryptor_key.presence || NON_PROD_ENCRYPTOR_KEY if non_production_like
                                   env_encryptor_key
                                 end
    end
  end
end
