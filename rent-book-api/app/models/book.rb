class Book < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :register_book_details, dependent: :destroy
  has_many :images, as: :imagetable, dependent: :destroy

  accepts_nested_attributes_for :images

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

  scope :recent, ->{order created_at: :desc}
  scope :available, ->{where "quantity > ?", 0}
  scope :by_ids, ->(ids){where id: ids}
  scope :hot_books, (lambda do |limit|
    joins(register_book_details: [:register_book])
    .select("books.*")
    .where("MONTH(register_book_details.created_at) = ? and register_books.status IN (?) ",
           Time.zone.now.month, [RegisterBook.statuses[:pending], RegisterBook.statuses[:approved]])
    .group("books.id")
    .order("sum(register_book_details.quantity) desc")
    .limit(limit)
  end)
end
