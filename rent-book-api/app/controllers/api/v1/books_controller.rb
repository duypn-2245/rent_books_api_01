module Api::V1
  class BooksController < ApplicationController
    before_action :authenticate_request!, only: %i(index show)
    before_action :preload_book, only: :show

    load_and_authorize_resource

    def index
      page = params[:page] || Settings.per_page.default_1
      per_page = params[:per] || Settings.show_limit_per_page.book.index_limit
      books = Book.recent.page(page).per(per_page)
      json_response books, meta_pagination(page, per_page, books)
    end

    def show
      json_response @book
    end

    private

    def preload_book
      @book = Book.find params[:id]
    end
  end
end