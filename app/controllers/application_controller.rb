# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :logged_out?

  def current_user
    User.find_by(id: session[:current_user])
  end

  def logged_in?
    current_user.is_a? User
  end

  def logged_out?
    !logged_in?
  end
end
