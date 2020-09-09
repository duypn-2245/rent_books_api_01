module Authenticable
  def authenticate_request!
    return if current_user.present?
  end

  def http_token
    return request.headers["Authorization"].split(" ").last if request.headers["Authorization"].present?

    raise ExceptionHandler::MissingToken
  end

  def auth_token
    JsonWebToken.decode(http_token)
  end

  def current_user
    @current_user = User.find auth_token[:user_id].to_i
  end
end
