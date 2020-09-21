class UpdateQuantityBooksInCancelService
  def initialize register_book, status
    @register_book = register_book
    @status = status
  end

  def perform
    @arr_books = []
    @register_book.register_book_details.includes(:book).each do |register_book_detail|
      register_book_detail.book.quantity += register_book_detail.quantity
      @arr_books << register_book_detail.book
    end
    ActiveRecord::Base.transaction do
      @register_book.update! status: @status
      Book.import @arr_books, on_duplicate_key_update: [:quantity]
    end
    @register_book
  end
end
