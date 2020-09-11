module ExceptionHandler
  extend ActiveSupport::Concern

  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class MissingToken < StandardError; end
  class MisstingParams < StandardError; end

  included do
    rescue_from ExceptionHandler::DecodeError do |_error|
      response_json I18n.t("errors.json_web_token.invalid_token"), :unauthorized
    end

    rescue_from ExceptionHandler::ExpiredSignature do |_error|
      response_json I18n.t("errors.json_web_token.expired_token"), :unauthorized
    end

    rescue_from ActiveRecord::RecordNotFound do |_error|
      response_json I18n.t("errors.not_found_data"), :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |_error|
      response_json I18n.t("errors.invalid_data"), :unprocessable_entity
    end

    rescue_from ExceptionHandler::MissingToken do |_error|
      response_json I18n.t("errors.missing_token"), :unprocessable_entity
    end

    rescue_from ExceptionHandler::MisstingParams do |_error|
      response_json I18n.t("errors.missing_params"), :unprocessable_entity
    end
  end

  private

  def response_json message, status
    render json: {
      messages: message
    }, status:  status
  end
end
