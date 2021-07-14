# frozen_string_literal: true

module TokenAuthentication
  extend ActiveSupport::Concern

  def authenticate_by_token
    return if request.headers[:authorization].blank?

    auth = JSON.parse(Base64.decode64(request.headers[:authorization]))

    @current_user = User.find_by!(
      email: auth['email'],
      api_token: auth['token']
    )
  end
end
