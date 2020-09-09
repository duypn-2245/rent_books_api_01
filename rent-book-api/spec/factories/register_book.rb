require "faker"

FactoryBot.define do
  factory :register_book do
    user{User.first || association(:user)}
    start_date{Time.current}
    intended_end_date{Time.current + 10}
  end
end
