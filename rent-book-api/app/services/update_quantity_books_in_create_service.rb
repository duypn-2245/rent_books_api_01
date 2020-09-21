class UpdateQuantityBooksInCreateService
  def initialize create_params
    @create_params = create_params
  end

  def perform
    check_exist_books
    check_quantity_per_book
  end

  private

  def covert_book_requests
    request_details = {}
    book_requests = @create_params[:register_book_details_attributes]
    book_requests.each do |request|
      id = request[:book_id].to_s
      request_details[id] = request[:quantity].to_i
    end
    request_details
  end

  def check_exist_books
    @request_details = covert_book_requests
    book_request_ids = @request_details.keys
    @books = Book.by_ids(book_request_ids)
    raise ActiveRecord::RecordNotFound unless @books.size == book_request_ids.size
  end

  def check_quantity_per_book
    @errors = []
    @arr_books = []
    @books.each do |book|
      if @request_details[book.id.to_s] > book.quantity
        @errors << I18n.t("errors.not_enough", name: book.title, number: book.quantity)
      else
        book.quantity -= @request_details[book.id.to_s]
        @arr_books << book
      end
    end
    response_json @errors, :unprocessable_entity if @errors.present?
    @arr_books
  end
end
