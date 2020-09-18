require "faker"

FactoryBot.define do
  factory :register_book_detail do
    register_book
    book
    quantity{Faker::Number.within(range: 1..3)}
    rent_cost{Faker::Number.digit}
  end
end
