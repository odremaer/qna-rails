require 'rails_helper'

feature 'Author can delete question', %q{
  In order to delete my own question
  As an author
  I'd like to be able to delete my question
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }

  given(:question) { create(:question, user: first_user) }

  scenario 'author tries to delete question' do
    sign_in(first_user)

    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Question deleted successfully'
    expect(page).to_not have_content question.title
  end

  scenario 'not author tries to delete question' do
    sign_in(second_user)

    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

  scenario 'not signed in user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
