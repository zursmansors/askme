FactoryGirl.define do
  sequence(:title) { |n| "Question title #{n}" }

  factory :question do
    title 'MyString'
    body 'MyText'
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end


