# frozen_string_literal: true

class UserAuthAction < LightServiceExt::ApplicationAction
  expects :params

  executed do |ctx|
    user = User.find(ctx.dig(:params, :email))
    add_params(ctx, user_id: user&.id)

    add_errors(ctx, email: I18n.t('errors.not_found')) if user.nil?

    password = ctx.dig(:params, :password)
    encrypted_password = user&.password
    unless PasswordEncryptor.secure_compare?(password, encrypted_password)
      add_errors(ctx, email: I18n.t('errors.invalid_credentials'))
    end
  end
end
