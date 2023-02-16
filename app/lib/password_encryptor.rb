module PasswordEncryptor
  DEVELOPMENT_COST = 10
  TEST_COST = 6

  class << self
    attr_writer :cost

    def encrypt(password)
      BCrypt::Password.create(password)
    end

    def secure_compare?(password, encrypted_password)
      BCrypt::Password.new(encrypted_password) == password
    end

    def cost
      @cost ||= begin
                  return DEVELOPMENT_COST if Rails.env.development?
                  return TEST_COST if Rails.env.test?

                  Crypt::Engine.cost
                end
    end
  end
end
