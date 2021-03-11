require 'rails_helper'

feature 'Author can delete question', %q{
  In order to delete my own question
  As an author
  I'd like to be able to delete my question
} do

  given(:question) { create(:question) }
  given(:users) { create_list(:user, 2) }

  scenario 'author tries to delete question' do
    sign_in(users[0])
    users[0].questions.push(question)

    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Question deleted successfully'
    expect(page).to_not have_content question.title
  end

  scenario 'not author tries to delete question' do
    sign_in(users[1])

    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'You are not author of this question'
  end

  scenario 'not signed in user tries to delete question' do
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
