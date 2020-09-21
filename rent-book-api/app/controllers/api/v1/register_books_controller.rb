class Api::V1::RegisterBooksController < ApplicationController
  before_action :authenticate_request!
  before_action :must_have_least_one, only: :create
  before_action :preload_register_book, only: :update

  authorize_resource

  def index
    page = params[:page] || Settings.per_page.default_1
    per_page = params[:per] || Settings.show_limit_per_page.register_book.index_limit
    register_books = @current_user.register_books.recent.page(page).per(per_page)
    json_response register_books, meta_pagination(page, per_page, register_books)
  end

  def create
    @arr_books = UpdateQuantityBooksInCreateService.new(create_params).perform
    ActiveRecord::Base.transaction do
      @register_book = RegisterBook.create! create_params
      Book.import @arr_books, on_duplicate_key_update: [:quantity]
    end
    response_json I18n.t("register_books.create.success"), :created, @register_book
  end

  def update
    status = params[:status].to_i
    if @register_book.pending? && (status == RegisterBook.statuses[:canceled])
      @register_book = UpdateQuantityBooksInCancelService.new(@register_book, status).perform
      response_json I18n.t("register_books.update.success"), :ok, @register_book
    else
      response_json I18n.t("register_books.update.not_permited"), :forbidden
    end
  end

  private

  def create_params
    params.require(:register_book).permit(:start_date, :intended_end_date,
                                          register_book_details_attributes: [:quantity, :rent_cost, :book_id])
          .merge(user_id: @current_user.id)
  end

  def must_have_least_one
    book_requests = create_params[:register_book_details_attributes]
    raise ExceptionHandler::MustHaveLeastOne if book_requests.blank?
  end

  def preload_register_book
    @register_book = RegisterBook.find_by! id: params[:id]
  end
end
