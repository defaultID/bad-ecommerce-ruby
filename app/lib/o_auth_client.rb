# frozen_string_literal: true

class OAuthClient
  class Error < RuntimeError; end

  extend Dry::Initializer

  option :endpoint, default: -> { 'http://auth.secureflag:18080/auth/realms/VulnerableApp/protocol/openid-connect/' }
  option :client_id, default: -> { 'application-login' }
  option :client_secret, default: -> { '94ce7840-ef8f-4215-8a36-39b6dfcd88dd' } # XXX: don't store real secrets in code
  option :redirect_uri
  option :http, default: -> { Faraday.new(url: endpoint) }

  class << self
    def instance(...)
      @instance ||= new(...)
    end
  end

  def authenticate_user_from_code(code)
    access_token = get_access_token(code)
    validate_access_token(access_token)
  rescue StandardError
    raise Error, 'Cannot authenticate user'
  end

  def authenticate_user_from_access_token(access_token)
    validate_access_token(access_token)
  rescue StandardError
    raise Error, 'Cannot authenticate user'
  end

  private

  def get_access_token(code)
    response = http.post(
      'token',
      {
        grant_type: 'authorization_code',
        client_id: client_id,
        client_secret: client_secret,
        redirect_uri: redirect_uri,
        code: code,
      }
    )
    response_object = JSON.parse(response.body)

    response_object['access_token']
  end

  def validate_access_token(access_token)
    response = http.get(
      'userinfo',
      nil,
      {
        authorization: "Bearer #{access_token}",
      }
    )
    response_object = JSON.parse(response.body)

    response_object['preferred_username']
  end
end
