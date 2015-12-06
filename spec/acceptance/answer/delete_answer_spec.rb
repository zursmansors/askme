require 'rails_helper'

feature 'Delete the answer', %q{
  In order to delete answer
  as an user
  I want to be able delete answer
} do

  given!(:user) { create :user }
  given!(:question) { create(:question, user: user) }
  given!(:answer){ create(:answer, question: question, user: user)}

  scenario 'Authenticated user tries to delete his own answer' do
    sign_in user

    visit question_path(question)

    click_on 'Delete answer'
    expect(page).to have_content 'Answer has been deleted.'
    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user tries to delete someone other\'s answer' do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Not authenticated user tries to delete an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end