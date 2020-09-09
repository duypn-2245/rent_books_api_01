class Api::V1::Admin::BooksController < ApplicationController
  before_action :load_book, only: %i(show update destroy book_renter)
  before_action :authenticate_request!
  before_action :check_params_statisticals, only: :statisticals
  authorize_resource

  def index
    search_and_sort
    page = params[:page] || Settings.book.page
    per_page = params[:per_page] || Settings.book.per_page
    books = @search.result.page(page).per(per_page)
    json_response books, meta_pagination(page, per_page, books)
  end

  def show
    json_response @book
  end

  def create
    book = Book.create!(book_params)
    json_response book
  end

  def update
    @book.update! book_params
    json_response @book
  end

  def destroy
    @book.destroy!
    response_status :ok
  end

  def book_renter
    page = params[:page] || Settings.register_book.page
    per_page = params[:per_page] || Settings.register_book.per_page
    register_books = @book.register_book_details.book_renter.page(page).per(per_page)
    json_response_with_custom_serializer register_books, RentBookSerializer,
                                         meta_pagination(page, per_page, register_books)
  end

  def search_and_sort
    @search = Book.ransack(params[:search])
    @search.sorts = params[:sort] || Settings.book.sort_by_created_at
  end

  def statisticals
    start_time = params[:start_time]
    end_time = params[:end_time]
    books = Book.statistical(start_time, end_time, Settings.book.hot_books.limit)
    meta = {start_time: start_time, end_time: end_time}
    json_response_with_custom_serializer books, BookStatisticalSerializer, meta
  end

  private

  def load_book
    @book = Book.find_by! id: params[:id]
  end

  def book_params
    params.permit :title, :description, :author, :image, :quantity, :rent_cost,
                  images_attributes: [:id, :photo]
  end

  def check_params_statisticals
    raise ExceptionHandler::MissingParams if params[:start_time].blank? || params[:end_time].blank?
  end
end
