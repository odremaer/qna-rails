require 'rails_helper'

feature 'User can write answer for question', %q{
  In order to help the community
  As an autheticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'text text text'
      click_on 'Answer'

      # checks if user can see answers for question
      expect(page).to have_content 'text text text'
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unautheticated user answers the question' do
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
