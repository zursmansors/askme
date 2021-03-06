require_relative '../acceptance_helper'

feature 'Show questions titles list', %q{
  In order to choose an interesting question
  As a guest
  I want to be able to see the questions list
} do

  given(:user) { create :user }
  given!(:questions) { create_list(:question,2, user: user) }

  scenario 'Any user looks over the questions titles list' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end