module Api::V1
  class RegistrationsController < ApplicationController
    before_action :ensure_params_exist, only: :create

    def create
      user = User.new sign_up_params
      user.save!
      response_json I18n.t("registrations.create.signed_up"), :created, JsonWebToken.encode(user_id: user.id)
    end

    private

    def sign_up_params
      params.require(:sign_up).permit :email, :password, :password_confirmation, :name
    end

    def ensure_params_exist
      raise ExceptionHandler::MissingParams if params[:sign_up].blank? || sign_up_params[:password_confirmation].blank?
    end
  end
end
