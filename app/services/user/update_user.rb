# frozen_string_literal: true

class User
  class UpdateUser < BaseService
    option :target
    option :actor

    private

    def _call(params:)
      result = validate(params.permit!.to_h)

      if result.success?
        persist result
      else
        invalid target, result
      end
    end

    def validate(params)
      User::UpdateUserContract.new.call(params)
    end

    def persist(result)
      target.update! result.to_h
      target
    end
  end
end
