# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authorizable

  if Rails.env.development? || Rails.env.test?
    protect_from_forgery with: :null_session
  else
    protect_from_forgery with: :exception # helps protects against CSRF
  end

  before_action :require_login

  rescue_from Exception, with: :render_server_error

  protected

  def render_success(params = {})
    render json: params, status: 200
  end

  def render_created(params = {})
    render json: params, status: 201
  end

  def render_bad_request(error_messages)
    render_error(error_messages, 400)
  end

  def render_unauthorized_error(error_messages)
    render_error(error_messages, 401)
  end

  private

  def render_server_error(exception)
    error_with_filtered_backtrace = <<-ERROR
    \n\n =========== SERVER ERROR FOUND: #{exception.class.name }:#{exception.message} ===========\n\n
    #{Rails.backtrace_cleaner.clean(exception.backtrace).join("\n")}
    \n\n #{'=' * 100} \n\n
    ERROR

    Rails.logger.error(error_with_filtered_backtrace)

    render_error({ error: I18n.t('errors.internal_server_error') }, 500)
  end

  def render_error(error_messages, http_status_code)
    render json: { errors: error_messages }, status: http_status_code
  end

  def require_login
    session_state = cookies[SESSION_STATE_KEY]
    return render_unauthorized if session_state.blank?

    decrypted_session_state = Encryptor.decrypt(session_state)
    login_session = LoginSession.find(decrypted_session_state[:session_id])

    render_unauthorized if login_session.nil?
  end

  def render_unauthorized
    render_unauthorized_error({ email: I18n.t('errors.unauthorized') })
  end
end
