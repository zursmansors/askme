require_relative '../acceptance_helper'

feature 'Delete the answer', %q{
  In order to delete answer
  as an user
  I want to be able delete answer
} do

  given!(:user) { create :user }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user)}

  scenario 'Authenticated user tries to delete his own answer', js: true do
    sign_in user

    visit question_path(question)

    click_on 'Delete answer'

    within '.answers' do
      expect(page).to_not have_content answer.body
    end
    expect(page).to have_content 'Answer has been deleted.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to delete someone other\'s answer', js: true do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Not authenticated user tries to delete an answer', js: true do
    visit question_path(question)

   within '.answers' do
    expect(page).to_not have_content 'Delete answer'
  end

  end
end