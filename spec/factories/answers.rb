FactoryGirl.define do
  sequence(:body) { |n| "My answer #{n}" }

  factory :answer do
    body "MyText"
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question
    user
  end
end
