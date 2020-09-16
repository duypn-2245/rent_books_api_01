module Authenticable
  def authenticate_request!
    @current_user = User.find auth_token[:user_id].to_i
  end

  def http_token
    return request.headers["Authorization"].split(" ").last if request.headers["Authorization"].present?

    raise ExceptionHandler::MissingToken
  end

  def auth_token
    JsonWebToken.decode(http_token)
  end
end
