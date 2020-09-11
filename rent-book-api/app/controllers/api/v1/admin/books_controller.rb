class Api::V1::Admin::BooksController < ApplicationController
  before_action :load_book, only: %i(show update destroy)
  before_action :authenticate_request!
  authorize_resource

  def index
    page = params[:page] || Settings.book.page
    per_page = params[:per_page] || Settings.book.per_page
    books = Book.page(page).per(per_page)
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

  private

  def load_book
    @book = Book.find_by! id: params[:id]
  end

  def book_params
    params.permit :title, :description, :author, :image, :quantity, :rent_cost,
                  images_attributes: [:id, :photo]
  end
end
