require "faker"

FactoryBot.define do
  factory :user do
    name{Faker::Name.name}
    email{Faker::Internet.free_email}
    password{123_456}
    password_confirmation{123_456}
  end

  trait :user do
    role{User.roles[:user]}
  end

  trait :admin do
    role{User.roles[:admin]}
  end
end
