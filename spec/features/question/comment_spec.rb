require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to comment question
  As an authenticated user
  I'd like to be able to comment questions
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'comments question' do
      fill_in 'Your comment:', with: 'test comment'

      click_on 'comment'

      expect(page).to have_content 'test comment'
    end
  end

  describe 'Unautheticated user' do
    scenario "can't comment question" do
      visit question_path(question)

      expect(page).to_not have_link 'comment'
      expect(page).to_not have_content "Your comment:"
    end
  end

  describe 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your comment:', with: 'test comment'

        click_on 'comment'

        expect(page).to have_content 'test comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'test comment'
      end
    end
  end
end
