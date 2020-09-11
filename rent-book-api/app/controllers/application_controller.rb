class ApplicationController < ActionController::API
  include ExceptionHandler
  include Authenticable
  include Response

  before_action :set_locale

  def default_url_options
    {locale: I18n.locale}
  end

  def meta_pagination page, per_page, object
    {
      page: page,
      per_page: per_page,
      total_page: object.total_pages
    }
  end

  private

  def set_locale
    parsed_locale = I18n.available_locales.map(&:to_s).include?(params[:locale]) ? params[:locale] : nil
    I18n.locale = parsed_locale || I18n.default_locale
  end
end
