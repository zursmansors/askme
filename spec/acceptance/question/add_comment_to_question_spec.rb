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
    fill_in 'Comment', with: 'Test comment'
    click_on 'Add comment'

    expect(page).to have_content 'Test comment'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Non-authenticated user tries to comment question' do
    visit question_path question
    expect(page).to_not have_content 'Add comment'
  end
end