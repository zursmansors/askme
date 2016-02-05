require_relative '../acceptance_helper'

feature 'Add comment to question', %q{
  In order to clearing question
  As an authenticated user
  I want to be able to add comment to question
} do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user comments question', js: true do
    sign_in user
    visit question_path question

    within '.comment' do
      fill_in 'Comment', with: 'Test comment'
      click_on 'Add Comment'
    end

    expect(page).to have_content 'Test comment'
  end

  scenario 'Non-authenticated user tries to comment question' do
    visit question_path question
    within '.question-comments' do
      expect(page).to_not have_content 'Add Comment'
    end
  end
end