require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answers from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text, text'
    click_on 'Create'

    expect(page).to have_content 'Question was successfully created.'
  end

  scenario 'Not authenticated user tries create question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end
end