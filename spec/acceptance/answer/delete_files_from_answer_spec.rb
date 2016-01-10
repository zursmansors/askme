require_relative '../acceptance_helper'

feature 'Delete file from question', %q{
  In order to discard file from the answer
  As an answer's author
  I want to remove attachment
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:file) { create(:attachment, attachable: answer) }

  scenario 'User remove attachment during edit answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Edit'
      click_on 'Remove Attachment'
      click_on 'Save'
    end

    expect(page).to_not have_link 'rails_helper.rb'
  end

  scenario 'Another user try to remove attachment during edit answer ', js: true do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_content 'Edit'
    end
  end
end