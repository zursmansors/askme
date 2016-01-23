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

    scenario 'Not question owner sees the links for voting question', js: true do
      visit question_path(foreign_question)

      within '.question-votes' do
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
        expect(page).to_not have_link 'Reset'
      end
    end

    scenario 'Not question owner votes for question', js: true do
      visit question_path(foreign_question)

      within '.question-votes' do
        click_on 'Up'
        save_and_open_page
        expect(page).to have_link 'Reset'
        expect(page).to have_content '1'
      end
    end
  end
end




# feature 'Vote to question scenarios' do
#   let!(:user) { create :user }
#   let!(:question) { create :question, user: user }
#   let!(:another_user) { create :user }
#   let!(:foreign_question) { create :question, user: another_user }
#   let(:vote) { create :vote, voteable: foreign_question, value: 1, user: user }

#   describe 'Non authenticated user' do
#     it 'User dose not see vote links', js: true do
#       visit question_path(question)
#       within '#question-area' do
#         expect(page).to_not have_link("+")
#         expect(page).to_not have_link("-")
#         expect(page).to_not have_link 'Cancel my vote'
#       end
#     end
#   end

#   describe 'Authenticated user' do
#     before { sign_in user }
#     context 'Foreign question' do
#       before { visit question_path(foreign_question) }
#       it 'User see vote links' do
#         within '#question-area' do
#           expect(page).to have_link("+")
#           expect(page).to have_link("-")
#         end
#       end

#       it 'click plus link', js: true do
#         within '#question-area' do
#           click_link '+'
#           expect(page).to_not have_link '+'
#           expect(page).to_not have_link '-'
#           expect(page).to have_content 'Votes 1'
#         end
#       end

#       it 'click minus link', js: true do
#         within '#question-area' do
#           click_link '-'
#           expect(page).to_not have_link '+'
#           expect(page).to_not have_link '-'
#           expect(page).to have_content 'Votes -1'
#         end
#       end
#     end

#     context 'Own question' do
#       it 'Dosent see vote links' do
#         visit question_path(question)
#         within '#question-area' do
#           expect(page).to_not have_link("+")
#           expect(page).to_not have_link("-")
#           expect(page).to_not have_link 'Cancel my vote'
#         end
#       end
#     end

#     context 'Foreign has user vote' do
#       before do
#         vote
#         visit question_path(foreign_question)
#       end

#       it 'Can cancel vote', js: true do
#         within '#question-area' do
#           expect(page).to have_link 'Cancel my vote'
#           click_link 'Cancel my vote'
#           expect(page).to have_content 'Votes 0'
#         end
#       end

#       it 'Can change vote', js: true do
#         within '#question-area' do
#           expect(page).to have_link 'Cancel my vote'
#           click_link 'Cancel my vote'
#           click_link '-'
#           expect(page).to have_content 'Votes -1'
#         end
#       end


#       it 'Can not vote second time', js: true do
#         within '#question-area' do
#           expect(page).to_not have_link '+'
#           expect(page).to_not have_link '-'
#         end
#       end

#     end


#   end
# end