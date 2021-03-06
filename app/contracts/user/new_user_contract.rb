# frozen_string_literal: true

class User
  class NewUserContract < User::UpdateUserContract
    # No target and actor in new user registration
    option :actor, optional: true
    option :target, optional: true

    params(User::UpdateUserContract.schema) do
      required(:email).filled(:string)
      required(:password).filled(:string)
      required(:password_confirmation).filled(:string)
    end

    rule(:password, :password_confirmation) do
      key.failure('must match confirmation') unless values[:password] == values[:password_confirmation]
    end
  end
end
