require "faker"

FactoryBot.define do
  factory :book do
    title{Faker::Name.name}
    description{Faker::Lorem.sentence}
    author{Faker::Name.name}
    quantity{Faker::Number.within(range: 5..10)}
    rent_cost{Faker::Number.digit}
  end
end
