module Api::V1
  class SessionsController < ApplicationController
    before_action :ensure_params_exist, :load_user, only: :create
    before_action :authenticate_request!, only: :destroy

    def create
      raise ActiveRecord::RecordNotFound unless @user.valid_password? params[:password]

      response_json I18n.t("sessions.create.signed_in"), :ok, JsonWebToken.encode(user_id: @user.id)
    end

    def destroy
      response_json I18n.t("sessions.destroy.signed_out"), :ok
    end

    private

    def ensure_params_exist
      raise ExceptionHandler::MissingParams unless params[:email].present? && params[:password].present?
    end

    def load_user
      @user = User.find_by! email: params[:email]
      raise ActiveRecord::RecordNotFound unless @user
    end
  end
end
