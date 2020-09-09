class Book < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :register_book_details, dependent: :destroy

  validates :title, presence: true,
                    length: {maximum: Settings.book.title.maximum}
  validates :description, presence: true,
                          length: {maximum: Settings.book.description.maximum}
  validates :author, presence: true,
                     length: {maximum: Settings.book.author.maximum}
  validates :quantity, numericality: {only_integer: true,
                                      greater_than_or_equal_to: Settings.book.quantity.gteq}
  validates :rent_cost, numericality: {greater_than_or_equal_to:
                                         Settings.book.rent_cost.gteq}
end