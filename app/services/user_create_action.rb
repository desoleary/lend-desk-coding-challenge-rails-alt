class UserCreateAction < LightServiceExt::ApplicationAction
  expects :params

  executed do |ctx|
    attrs = ctx.dig(:params).slice(:email, :password, :password_confirmation)

    existing_user = User.find(attrs[:email])
    add_errors(ctx, email: I18n.t('errors.already_exists', name: 'user')) if existing_user.present?

    add_params(ctx, user_id: User.create(attrs).id)
  end
end
