# frozen_string_literal: true

class ApplicationContract < Dry::Validation::Contract
  PASSWORD_REQUIREMENTS_MAP = {
    password_min_length: Regex::PASSWORD_MIN_LENGTH,
    password_min_numerics: Regex::PASSWORD_MIN_NUMERICS,
    password_min_uppercase: Regex::PASSWORD_MIN_UPPERCASE,
    password_min_lowercase: Regex::PASSWORD_MIN_LOWERCASE,
    password_min_symbols: Regex::PASSWORD_MIN_SYMBOLS
  }.freeze

  register_macro(:password) do
    PASSWORD_REQUIREMENTS_MAP.each_pair do |type, min_length|
      key.failure(I18n.t("errors.#{type}", min: min_length)) unless Regex.match?(type, value)
    end
  end

  register_macro(:email) do
    key.failure(I18n.t('errors.email')) unless Regex.match?(:email, value)
  end
end
