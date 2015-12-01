require 'rails_helper'

feature 'User sign up', %q{
  In order to be able ask a question as a new user
  I want to be able to sign up
} do

  scenario 'Not existed user tries to sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'new_user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'
    expect(page).to have_content 'You have signed up successfully.'
  end

  given(:user) { create(:user) }
  scenario 'Existed user tries to sign up' do
    sign_in(user)
    visit new_user_registration_path
    expect(page).to have_content 'You are already signed in.'
  end
end