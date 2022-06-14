class AuthenticationTokenService < BaseService
  HMAC_SECRET = Rails.application.secrets.secret_key_base
  ALGORITHM_TYPE = 'HS256'.freeze

  def initialize(user_id)
    @user_id = user_id
  end

  def self.decode(token)
    JWT.decode token, HMAC_SECRET, true, { algorithm: ALGORITHM_TYPE }
  rescue JWT::ExpiredSignature, JWT::DecodeError
    false
  end

  def self.valid_payload?(payload)
    Time.at(payload['exp']) >= Time.now
  rescue StandardError
    false
  end

  def call
    exp = 24.hours.from_now.to_i
    payload = { user_id: @user_id, exp: exp }
    JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
  end
end
