require 'rails_helper'

feature 'User can write answer for question', %q{
  In order to help the community
  As an autheticated user
  I'd like to be able to answer the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

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

    scenario 'answers the question with attached file' do
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unautheticated user answers the question' do
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  describe 'multiple sessions', js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'text text text'

        click_on 'Answer'

        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'text text text'
        end
      end
    end
  end
end
