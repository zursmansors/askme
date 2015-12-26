require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  In order to mark answer as the most usefull
  As an author of question
  I'd like be able to set the answer as the best
} do

  given(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:foreign_question) { create(:question, user: another_user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  # given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'Unauthenticated user tries to set the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'sees the link Set as the best' do
      within '.answers' do
        expect(page).to have_link 'Set as the best'
      end
    end

    scenario 'tries to set the answer as the best', js: true do
      within '.answers' do
        click_on 'Set as the best'
        expect(page).to_not have_link "Set as the best"
        expect(page).to have_content 'Best answer'
      end
    end

    scenario 'best answer has first position in the list of answers', js:true do
      within '.answers' do
        click_on "Set as the best"
      end

      within '.answers > :nth-child(2)' do
        expect(page).to have_content 'Best answer'
      end
    end

    scenario 'tries to set the answer as the best to other user\'s question', js:true  do
      visit question_path(foreign_question)
      expect(page).to_not have_link "Set as the best"
    end
  end
end