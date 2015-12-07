require 'rails_helper'

feature 'Create answer', %q{
  In order to answer on concrete question
  As an authenticated user
  I want to be able to create answers
} do

  given(:user) {create(:user)}
  given(:question){create(:question, user: user)}

  scenario 'Authenticated user create answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your answer', with: 'My answer'
    click_on 'Add answer'
    within '.answers' do      
      expect(page).to have_content 'My answer'
    end
    expect(page).to have_content 'Answer has been created'
  end

  scenario 'Not authenticated user tries create an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Add answer'
  end
end