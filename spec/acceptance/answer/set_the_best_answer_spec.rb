require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  In order to mark answer as the most usefull
  As an author of question
  I'd like be able to set the answer as the best
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  # given(:others_question) { create(:question) }
  # given!(:answer) { create(:answer, question: question) }
  # given!(:others_answers) { create(:answer, question: others_question) }

  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries to set the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end


  # describe 'Authenticated user' do
  #   before do
  #     sign_in user
  #     visit question_path(question)
  #   end

  #   scenario 'sees link to Лучший ответ' do
  #     expect(page).to have_link 'Лучший ответ'
  #   end

  #   scenario 'try to set best answer', js: true do
  #     click_on 'Лучший ответ'

  #     expect(page).to have_content 'Этот ответ является лучшим'
  #     expect(page).to_not have_link 'Лучший ответ'
  #   end

  #   scenario "try to set best answer to others user's question", js: true do
  #     visit question_path(others_question)
  #     expect(page).to_not have_link 'Лучший ответ'
  #   end
  # end
end