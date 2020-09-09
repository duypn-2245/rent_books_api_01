class RegisterBookDetail < ApplicationRecord
  belongs_to :book
  belongs_to :register_book

  validates :quantity, numericality: {only_integer: true,
                                      greater_than_or_equal_to:
                                        Settings.register_book_detail.quantity.gteq}
  validates :rent_cost, numericality: {greater_than_or_equal_to:
                                        Settings.register_book_detail.rent_cost.gteq}
end
