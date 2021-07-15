# frozen_string_literal: true

class OauthController < ApplicationController
  class StateMismatch < StandardError; end

  before_action :skip_policy_scope

  def index
    login_with_code(oauth_params[:state], session[:oauth_state], oauth_params[:code])
  end

  private

  def login_with_code(state, session_state, code)
    raise StateMismatch, 'OAuth state does not match' unless state.present? && state == session_state

    oauth_client = OAuthClient.instance(redirect_uri: oauth_url)
    email = oauth_client.authenticate_user_from_code(code)

    sign_in_user(email)
  rescue StateMismatch, OAuthClient::Error, ActiveRecord::RecordNotFound => e
    reset_session
    redirect_to new_session_path, alert: e
  end

  def sign_in_user(email)
    user = User.find_by! email: email
    session[:current_user] = user.id

    return_to = session[:return_to].presence || root_path
    redirect_to return_to, notice: 'Logged in successfully'
  end

  def oauth_params
    params.permit(:state, :code)
  end
end
