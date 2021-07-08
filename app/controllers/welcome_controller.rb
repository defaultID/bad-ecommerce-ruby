# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :skip_policy_scope

  def index; end
end
