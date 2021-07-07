class User::CreateUser < BaseService
  private

  def _call(params:)
    result = validate(params.permit!.to_h)

    user =  if result.success?
              persist result
            else
              invalid User, result
            end
    user
  end

  def validate(params)
    User::NewUserContract.new.(params)
  end

  def persist(result)
    result = result.to_h
    result[:api_token] = SecureRandom.hex(16)

    User.create! result
  end
end
