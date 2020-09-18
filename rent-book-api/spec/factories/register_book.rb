require "faker"

FactoryBot.define do
  factory :register_book do
    user
    intended_end_date{Faker::Date.in_date_period}
    start_date{Faker::Date.in_date_period}
  end
end
