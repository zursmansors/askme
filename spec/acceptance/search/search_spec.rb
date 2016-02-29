require_relative '../acceptance_helper'

feature 'Search', %q{
  In order to find some text
  As an user
  I want to be able to use searching
} do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question, body: 'question body', user: user) }
  given!(:answer)   { create(:answer, body: 'answer body', question: question, user: user) }
  given!(:comment)  { create(:comment, body: 'comment body', commentable: question, user: user) }

  before do
    index
    visit root_path
  end

  scenario 'User search only questions', :js do

    within('.search-resources') do
      fill_in 'query', with: question.body
      select 'Question', from: 'resource'
      click_on 'Search'
    end

    expect(page).to have_link question.title
    expect(page).to have_content question.body
  end

  scenario 'User search only answers', :js do

    within('.search-resources') do
      fill_in 'query', with: answer.body
      select 'Answer', from: 'resource'
      click_on 'Search'
    end

    expect(page).to have_content answer.question.title
    expect(page).to have_content answer.body
  end

  scenario 'User search only comments', :js do

    within('.search-resources') do
      fill_in 'query', with: comment.body
      select 'Comment', from: 'resource'
      click_on 'Search'
    end

    expect(page).to have_content(comment.body)
  end

  scenario 'User search only users', :js do

    within('.search-resources') do
      fill_in 'query', with: user.email
      select 'User', from: 'resource'
      click_on 'Search'
    end

    expect(page).to have_content(user.email)
  end

  scenario 'User search anything', :js do

    within('.search-resources') do
      fill_in 'query', with: 'body'
      select 'Anything', from: 'resource'
      click_on 'Search'
    end

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
    expect(page).to have_content(answer.body)
    expect(page).to have_content(comment.body)
  end
end


