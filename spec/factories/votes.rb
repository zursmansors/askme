FactoryGirl.define do
  factory :vote do
    user
    value 0
    association :voteable
  end

end
