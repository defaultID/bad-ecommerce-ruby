# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  # rubocop:disable Lint/RedundantCopDisableDirective, Rails/LexicallyScopedActionFilter
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  # rubocop:enable Lint/RedundantCopDisableDirective, Rails/LexicallyScopedActionFilter

  helper_method :current_user, :logged_in?, :logged_out?

  def current_user
    @current_user ||= User.find_by(id: session[:current_user])
  end

  def logged_in?
    current_user.is_a? User
  end

  def logged_out?
    !logged_in?
  end

  rescue_from Pundit::NotAuthorizedError do |e|
    @error_message = e.message

    render 'error/show', status: :forbidden
  end

  private

  def require_login
    return if logged_in?

    session[:return_to] = request.fullpath if request.get?

    redirect_to new_session_path, status: :see_other
  end
end
