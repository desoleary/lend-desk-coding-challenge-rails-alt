module Authorizable
  extend ActiveSupport::Concern

  def render_with_login_session_for(user_id:)
    ctx = LoginSessionCreateOrganizer.call(user_id)
    return render_unauthorized_error(ctx.errors) if ctx.failure?

    login_state = ctx.params[:login_state]
    cookies[SESSION_STATE_KEY] = {
      expires: Time.at(login_state[:expires_at]),
      secure: Rails.configuration.force_ssl,
      domain: :all,
      httponly: true,
      value: Encryptor.encrypt({ last_request_at: Time.current.to_i }.merge(login_state))
    }

    render_created(ctx.params.slice(:user_id))
  end

  def reset_user_session
    reset_session
    cookies.delete SESSION_STATE_KEY, domain: :all
  end
end
