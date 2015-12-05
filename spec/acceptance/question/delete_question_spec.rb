require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question
  As authenticated user
  I want to delete question
} do

  given(:user) { create :user }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user tries to delete his own question' do
    sign_in user
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question has been deleted.'
    expect(current_path).to eq questions_path
  end

  scenario "User can not delete someone else's question" do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
