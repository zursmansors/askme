require_relative '../acceptance_helper'

feature "Show question and it's answers", %q{
  To find the answer to the current question
  Or create the answer to the current question,
  I want to be able to see the question and it's answers
} do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user tries to see a question and answers' do
    sign_in(user)

    visit question_path(question)
  end

  scenario 'Not authenticated user tries to see a question and answers' do
    visit question_path(question)
  end
end