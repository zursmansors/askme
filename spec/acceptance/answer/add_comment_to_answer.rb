require_relative '../acceptance_helper'

feature 'Add comment to answer', %q{
  In order to clearify answer
  As an authenticated user
  I want to be able to comment answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authencticated user create comment', js: true do
    sign_in(user)

    visit question_path(question)

    within '.answers' do
      fill_in 'Comment', with: 'Test comment'
      click_on 'Add comment'

      expect(page).to have_content 'Test comment'
    end
  end

  scenario 'Non-authencticated user ties create comment' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Add comment'
    end
  end
end