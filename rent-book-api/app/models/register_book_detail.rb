class RegisterBookDetail < ApplicationRecord
  belongs_to :book
  belongs_to :register_book

  validates :quantity, numericality: {only_integer: true,
                                      greater_than_or_equal_to:
                                        Settings.register_book_detail.quantity.gteq}
  validates :rent_cost, numericality: {greater_than_or_equal_to:
                                        Settings.register_book_detail.rent_cost.gteq}
  scope :book_renter, (lambda do
    joins(register_book: :user)
    .select("register_book_details.quantity", "register_book_details.rent_cost",
            "register_books.start_date", "register_books.intended_end_date",
            "register_books.end_date", "users.name", "id")
  end)
end
