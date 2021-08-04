# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :skip_authorization

  # GET /sessions/new
  def new
    set_return_to

    oauth_params = {
      response_type: 'code',
      client_id: 'application-login',
      redirect_uri: oauth_url,
    }
    @oauth_provider_url = "http://auth.secureflag:18080/auth/realms/VulnerableApp/protocol/openid-connect/auth?#{oauth_params.to_query}"
  end

  # POST /sessions
  def create
    user = User::Authenticate.new(session: session).call(params: params.require(:session))

    if user
      return_to = session[:return_to].presence || root_path
      redirect_to return_to, notice: 'Logged in successfully'
    else
      flash.now.alert = 'Authentication failed'
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /sessions/1 or /sessions/1.json
  def destroy
    reset_session

    redirect_to :root, notice: 'Logged out'
  end

  private

  def redirect_allowed?(referer)
    referer.host == request.host && referer.path != new_session_path
  end

  def set_return_to
    return if session[:return_to].present?

    referer = URI(request.headers[:referer])
    session[:return_to] = if redirect_allowed?(referer)
                            referer.query.present? ? "#{referer.path}?#{referer.query}" : referer.path
                          else
                            root_path
                          end
  rescue ArgumentError, URI::Error
    session[:return_to] = root_path
  end
end
