FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@test.com" }

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'
  end
end
