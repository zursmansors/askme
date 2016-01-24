require_relative '../acceptance_helper'

feature 'Vote for the answer', %q{
  In order to raise or lower the rating of the answer
  As authenticated user
  I want to be able to vote for the answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question){ create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:foreign_answer) { create(:answer, question: question, user: other_user) }

  scenario 'Unauthenticated user tries to vote for aswer' do
    visit question_path(foreign_answer.question)

    within '.answer-votes' do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
      expect(page).to_not have_link 'Reset'
    end
  end

  describe 'Authenticated user tries to vote for aswer', js: true  do
    before do
      sign_in(user)
    end

    scenario 'Answer owner does not see the links for voting aswer', js: true do
      visit question_path(answer.question)

      within '.answer-votes' do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to_not have_link 'Reset'
      end
    end

    scenario 'Not answer owner votes for aswer', js: true do
      visit question_path(foreign_answer.question)

      within '.answer-votes' do
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
      visit question_path(foreign_answer.question)

      within '.answer-votes' do
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