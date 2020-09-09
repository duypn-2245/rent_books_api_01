module ExceptionHandler
  extend ActiveSupport::Concern

  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class MissingToken < StandardError; end
  class MissingParams < StandardError; end
  class MustHaveLeastOne < StandardError; end

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

    rescue_from ActiveRecord::RecordInvalid, with: :response_json_with_invalid

    rescue_from ExceptionHandler::MissingToken do |_error|
      response_json I18n.t("errors.missing_token"), :unauthorized
    end

    rescue_from ExceptionHandler::MissingParams do |_error|
      response_json I18n.t("errors.missing_params"), :unprocessable_entity
    end

    rescue_from CanCan::AccessDenied do |_error|
      response_json I18n.t("errors.unauthorized"), :forbidden
    end

    rescue_from ActiveRecord::RecordNotDestroyed do |_error|
      response_json I18n.t("errors.detele_failed"), :internal_server_error
    end

    rescue_from ExceptionHandler::MustHaveLeastOne do |_error|
      response_json I18n.t("errors.least_one_book"), :unprocessable_entity
    end
  end

  private

  def response_json message, status
    render json: {
      messages: message
    }, status:  status
  end

  def response_json_with_invalid error
    render json: {
      messages: error.record.errors
    }, status: :unprocessable_entity
  end
end
