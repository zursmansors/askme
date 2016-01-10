require_relative '../acceptance_helper'

feature 'Delete file from question', %q{
  In order to discard file from the question
  As an question's author
  I want to remove attachment
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:file) { create(:attachment, attachable: question) }

  scenario 'User remove attachment from question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      expect(page).to have_link 'rails_helper.rb'

      click_on 'Edit question'
      click_on 'Remove Attachment'
      click_on 'Update Question'

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario 'Another user try to remove attachment from question', js: true do
    sign_in(another_user)
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_content 'Edit question'
    end
  end
end