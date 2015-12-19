require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question){ create(:question, user: user) }
  given!(:foreign_question) { create(:question, user: other_user) }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees the link to Edit question' do
      expect(page).to have_link 'Edit question'
    end

    scenario 'tries to edit his own answer', js: true do

      click_on 'Edit question'

      # save_and_open_page
      fill_in 'Title', with: 'edited title'
      fill_in 'Body', with: 'edited body'

      click_on 'Update Question'

      within '.question' do
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "try to edit other user's question", js: true do
      visit question_path(foreign_question)

      within '.question' do
        expect(page).to_not have_content 'Edit question'
      end
    end
  end
end