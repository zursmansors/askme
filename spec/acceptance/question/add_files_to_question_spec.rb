require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds several files when ask question', js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text, text'
    click_on 'Add file'
    all('input[type="file"]')[0].set "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Add file'
    all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
  end
end