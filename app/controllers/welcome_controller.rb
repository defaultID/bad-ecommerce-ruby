# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    @products = policy_scope(Product).order(created_at: :desc).limit(8)
  end

  def set_language
    skip_authorization

    settings['language'] = params[:lang] if LANGUAGES.include? params[:lang].to_sym

    write_settings

    redirect_back fallback_location: root_path
  end
end
