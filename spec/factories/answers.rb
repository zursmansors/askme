FactoryGirl.define do
  sequence(:body) { |n| "My answer #{n}" }

  factory :answer do
    body "MyText"
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
  end
end