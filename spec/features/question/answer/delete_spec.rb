require 'rails_helper'

feature 'Author can delete answer', %q{
  In order to delete my own answer
  As an author
  I'd like to be able to delete my answer
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, user: first_user, question: question) }

  scenario 'author tries to delete answer' do
    sign_in(first_user)

    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_content 'Answer deleted successfully'
    expect(page).to_not have_content answer.body
  end

  scenario 'not author tries to delete answer' do
    sign_in(second_user)

    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'not signed in user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
