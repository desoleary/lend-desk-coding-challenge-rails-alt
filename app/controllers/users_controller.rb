# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    ctx = UserCreateOrganizer.call(user_params)

    return render_bad_request(ctx.errors) if ctx.failure?

    render_with_login_session_for(user_id: ctx.params.slice(:user_id))
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation).to_h
  end
end
