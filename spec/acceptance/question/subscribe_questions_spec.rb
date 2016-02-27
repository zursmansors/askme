require_relative '../acceptance_helper'

feature 'Subscribe to the question', %q{
  In order to receive notifications with a new answer
  As an authenticated user
  I want to be able subscribe to the questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:subscription) { create(:subscription, question: question, user: user) }

  scenario 'Authenticated user tries to subscribe to the question', js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'Subscribe'

    within '.subscription' do
      expect(page).not_to have_link 'Subscribe'
      expect(page).to have_link 'Unsubscribe'
    end
  end

  scenario 'Unauthenticated user tries to subscribe to the question' do
    visit question_path(question)

    within '.subscription' do
      expect(page).not_to have_link 'Subscribe'
    end
  end
end
