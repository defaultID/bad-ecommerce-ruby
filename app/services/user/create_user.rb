# frozen_string_literal: true

class User
  class CreateUser < BaseService
    private

    def _call(params:)
      result = validate(params.permit!.to_h)

      if result.success?
        persist result
      else
        invalid User, result
      end
    end

    def validate(params)
      User::NewUserContract.new.call(params)
    end

    def persist(result)
      result = result.to_h
      result[:api_token] = SecureRandom.hex(16)

      User.create! result
    end
  end
end
