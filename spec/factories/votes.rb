FactoryGirl.define do
  factory :vote do
    user
    value 1
    association :voteable
  end

end
