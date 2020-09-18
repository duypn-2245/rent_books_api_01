class Api::V1::Admin::RegisterBooksController < ApplicationController
  before_action :authenticate_request!
  authorize_resource
  before_action :load_register_book, :load_books, only: :update

  def index
    search = RegisterBook.ransack(params[:search])
    page = params[:page] || Settings.register_book.page
    per_page = params[:per_page] || Settings.register_book.per_page
    register_books = search.result.page(page).per(per_page)
    json_response register_books, meta_pagination(page, per_page, register_books)
  end

  def update
    if params[:status] == Settings.register_book.status.rejected
      ActiveRecord::Base.transaction do
        @books.each do |book|
          rent_quantity = @register_book_details.find_by!(book_id: book.id).quantity
          book.update! quantity: book.quantity + rent_quantity
        end
        update_register_book_status
      end
    else
      update_register_book_status
    end
    json_response @register_book
  end

  private

  def update_register_book_status
    @register_book.update! status: params[:status]
  end

  def load_register_book
    @register_book = RegisterBook.find_by! id: params[:id]
  end

  def load_books
    @register_book_details = @register_book.register_book_details
    register_book_ids = @register_book_details.map(&:book_id)
    @books = Book.find(register_book_ids)
  end
end
