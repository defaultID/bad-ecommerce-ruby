# frozen_string_literal: true

class User
  class Authenticate < BaseService
    option :session

    private

    def _call(params:)
      result = validate(params.permit!.to_h)

      if result.success?
        persist find_user(result)
      else
        false
      end
    rescue ActiveRecord::RecordNotFound
      false
    end

    def validate(params)
      User::AuthContract.new.call(params)
    end

    def find_user(result)
      User.find_by! email: result[:email], encrypted_password: Digest::MD5.hexdigest(result[:password])
    end

    def persist(user)
      session[:current_user] = user.id
      user
    end
  end
end
