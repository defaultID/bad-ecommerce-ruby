# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :skip_authorization

  # GET /sessions/new
  def new
    set_return_to
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

  def set_return_to
    referer = URI(request.headers[:referer])
    session[:return_to] = if referer.host == request.host
                            referer.query.present? ? "#{referer.path}?#{referer.query}" : referer.path
                          else
                            root_path
                          end
  end
end
