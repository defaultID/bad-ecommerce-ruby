# frozen_string_literal: true

class ApplicationController < ActionController::Base
  LANGUAGES = Rails.application.config.i18n.available_locales.freeze

  include Pundit

  # rubocop:disable Lint/RedundantCopDisableDirective, Rails/LexicallyScopedActionFilter
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  # rubocop:enable Lint/RedundantCopDisableDirective, Rails/LexicallyScopedActionFilter
  around_action :apply_language

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
    @error = e

    render 'error/show', status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    @error = e

    render 'error/show', status: :not_found
  end

  private

  def require_login
    return if logged_in?

    session[:return_to] = request.fullpath if request.get?

    redirect_to new_session_path, status: :see_other
  end

  def apply_language(&action)
    locale = if settings[:language].present? && LANGUAGES.include?(settings[:language].to_sym)
               settings[:language]
             else
               LANGUAGES.first
             end

    I18n.with_locale(locale, &action)
  end

  def settings
    @settings ||= begin
      JSON.parse(cookies[:SETTINGS])
    rescue TypeError, JSON::ParserError
      {}
    end.with_indifferent_access
  end

  def write_settings
    cookies[:SETTINGS] = settings.to_json
  end
end
