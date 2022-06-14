class ApplicationController < ActionController::API
  include ExceptionHandler

  def authenticate_request!
    payload = extract_payload
    return invalid_authentication if !payload || !AuthenticationTokenService.valid_payload?(payload.first)
    current_user!
    invalid_authentication unless @current_user
  end

  def current_user!
    payload = extract_payload
    @current_user = User.find_by(id: payload[0]['user_id'])
  end

  private

  def extract_payload
    auth_header = request.headers['Authorization']
    AuthenticationTokenService.decode(auth_header.split(' ').last)
  rescue StandardError
    nil
  end

  def invalid_authentication
    json_response({ error: 'You will need to login first' }, :unauthorized)
  end
end
