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
end
