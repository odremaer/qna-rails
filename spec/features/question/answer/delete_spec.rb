require 'rails_helper'

feature 'Author can delete answer', %q{
  In order to delete my own answer
  As an author
  I'd like to be able to delete my answer
} do

  given(:question) { create(:question) }
  given(:answer) { create(:answer) }
  given(:users) { create_list(:user, 2) }

  scenario 'author tries to delete answer' do
    sign_in(users[0])

    question.answers.push(answer)
    users[0].answers.push(answer)

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'Answer deleted successfully'
    expect(page).to_not have_content answer.body
  end

  scenario 'not author tries to delete answer' do
    sign_in(users[1])
    question.answers.push(answer)

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'You are not author of this answer'
  end

  scenario 'not signed in user tries to delete question' do
    question.answers.push(answer)
    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
