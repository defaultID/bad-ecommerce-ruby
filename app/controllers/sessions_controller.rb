# frozen_string_literal: true

class SessionsController < ApplicationController
  # GET /sessions/new
  def new; end

  # POST /sessions
  def create
    user = User::Authenticate.new(session: session).call(params: params.require(:session))

    if user
      redirect_to :root, notice: 'Logged in successfully'
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
end
