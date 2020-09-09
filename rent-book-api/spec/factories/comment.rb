require "faker"

FactoryBot.define do
  factory :comment do
    content{Faker::Lorem.sentence}
    association(:book)
    association(:user)
    parent_id{nil}
  end
end
