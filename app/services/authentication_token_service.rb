class AuthenticationTokenService
  HMAC_SECRET = Rails.application.secrets.secret_key_base
  ALGORITHM_TYPE = "HS256".freeze

  def self.call(...)
    new(...).call
  end

  def initialize(user_id)
    @user_id = user_id
  end

  def call
    exp = 24.hours.from_now.to_i
    payload = {user_id: @user_id, exp: exp}
    JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
  end

  def self.decode(token)
    JWT.decode token, HMAC_SECRET, true, {algorithm: ALGORITHM_TYPE}
  rescue JWT::DecodeError, JWT::ExpiredSignature
    false
  end

  def self.valid_payload?(payload)
    Time.at(payload["exp"]) >= Time.now
  rescue
    false
  end
end
