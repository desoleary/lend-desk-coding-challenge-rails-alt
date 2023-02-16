class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    ctx = UserAuthOrganizer.call(user_params)
    return render_unauthorized_error(ctx.errors) if ctx.failure?

    render_with_login_session_for(user_id: ctx.params.slice(:user_id))
  end

  private

  def user_params
    params.require(:session).permit(:email, :password).to_h
  end

  def session_cookie
    cookies[SESSION_STATE_KEY]
  end
end
