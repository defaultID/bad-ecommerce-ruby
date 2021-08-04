# frozen_string_literal: true

class OauthController < ApplicationController
  class StateMismatch < StandardError; end

  before_action :skip_authorization
  before_action :set_oauth_client

  def code
    email = @oauth_client.authenticate_user_from_code(oauth_params[:code])

    sign_in_user(email)
  end

  def token
    email = @oauth_client.authenticate_user_from_access_token(oauth_params[:token])

    sign_in_user(email)
  end

  rescue_from StateMismatch, OAuthClient::Error, ActiveRecord::RecordNotFound do |e|
    reset_session
    redirect_to new_session_path, alert: e
  end

  private

  def set_oauth_client
    @oauth_client = OAuthClient.instance(redirect_uri: oauth_url)
  end

  def sign_in_user(email)
    user = User.find_by! email: email, locked: false
    session[:current_user] = user.id

    return_to = session[:return_to].presence || root_path
    redirect_to return_to, notice: 'Logged in successfully'
  end

  def oauth_params
    params.permit(:code, :token)
  end
end
