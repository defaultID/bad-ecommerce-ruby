# frozen_string_literal: true

class User
  class AuthContract < BaseContract
    params do
      required(:email).filled(:string)
      required(:password).filled(:string)
    end
  end
end
