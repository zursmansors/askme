FactoryGirl.define do
  sequence(:body) { |n| "Answer body #{n}" }

  factory :answer do
    body "MyText"
    # question ""
    # user
  end

  factory :invalid_answer, class: 'Answer' do
    # question nil
    body nil
    # user
  end
end
