module Regex
  PASSWORD_MIN_LENGTH = 8
  PASSWORD_MIN_NUMERICS = 1
  PASSWORD_MIN_UPPERCASE = 1
  PASSWORD_MIN_LOWERCASE = 1
  PASSWORD_MIN_SYMBOLS = 1

  PASSWORD_MIN_LENGTH_MATCH = /(?=.{#{PASSWORD_MIN_LENGTH},})/.freeze
  PASSWORD_MIN_NUMERICS_MATCH = /(?=.*\d{#{PASSWORD_MIN_NUMERICS},})/.freeze
  PASSWORD_MIN_UPPERCASE_MATCH = /(?=.*[A-Z]{#{PASSWORD_MIN_UPPERCASE},})/.freeze
  PASSWORD_MIN_LOWERCASE_MATCH = /(?=.*[a-z]{#{PASSWORD_MIN_LOWERCASE},})/.freeze
  PASSWORD_MIN_SYMBOLS_MATCH = /(?=.*[[:^alnum:]]{#{PASSWORD_MIN_SYMBOLS},})/.freeze

  TYPE = {
    password_min_length: PASSWORD_MIN_LENGTH_MATCH,
    password_min_numerics: PASSWORD_MIN_NUMERICS_MATCH,
    password_min_uppercase: PASSWORD_MIN_UPPERCASE_MATCH,
    password_min_lowercase: PASSWORD_MIN_LOWERCASE_MATCH,
    password_min_symbols: PASSWORD_MIN_SYMBOLS_MATCH,
    email: URI::MailTo::EMAIL_REGEXP
  }.freeze

  class << self
    def match?(type, value)
      TYPE[type].match?(value)
    end
  end
end
