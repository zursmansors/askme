require_relative '../acceptance_helper'

feature 'Vote for the question', %q{
  In order to raise or lower the rating of the question
  As authenticated user
  I want to be able to vote for the question
} do

  given(:user) { create :user }
  given(:other_user) { create(:user) }
  given(:question){ create(:question, user: user) }
  given(:foreign_question) { create(:question, user: other_user) }

  scenario 'Unauthenticated user tries to vote for question' do
    visit question_path(question)

    within '.question-votes' do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Reset'
    end
  end

  describe 'Authenticated user tries to vote for question', js: true  do
    before do
      sign_in(user)
    end

    scenario 'Question owner does not see the links for voting question', js: true do
      visit question_path(question)

      within '.question-votes' do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to_not have_link 'Reset'
      end
    end

    scenario 'Not question owner votes for question', js: true do
      visit question_path(foreign_question)

      within '.question-votes' do
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
        expect(page).to_not have_link 'Reset'

        click_on 'Up'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to have_link 'Reset'

        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'Reset vote', js: true do
      visit question_path(foreign_question)

      within '.question-votes' do
        expect(page).to have_content 'Rating: 0'

        click_on 'Up'
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_link 'Reset'

        click_on 'Reset'
        expect(page).to have_content 'Rating: 0'
        expect(page).to_not have_link 'Reset'
      end
    end
  end
end