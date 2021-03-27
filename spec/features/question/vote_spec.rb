require 'rails_helper'

feature 'User can vote for questions', %q{
  In order to rate a question
  As an user
  I'd like to be able to vote for questions
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    context 'not author' do
      scenario 'upvotes a question' do
        within '.question' do
          click_on 'upvote'
          within('#vote-rating') { expect(page).to have_content('1') }
        end
      end

      scenario 'downvote a question' do
        within '.question' do
          click_on 'downvote'
          within('#vote-rating') { expect(page).to have_content('-1') }
        end
      end

      scenario 'undo his vote' do
        within '.question' do
          click_on 'upvote'
          click_on 'undo vote'
          within('#vote-rating') { expect(page).to have_content('0') }
        end
      end
    end

    context 'author' do
      given(:question) { create(:question, user: user) }

      scenario 'votes' do
        expect(page).to_not have_link('upvote')
        expect(page).to_not have_link('downvote')
        expect(page).to_not have_link('undo vote')
      end
    end
  end

  describe 'Unauthencticated user' do
    scenario 'tries to vote for question' do
      visit question_path(question)

      expect(page).to_not have_link('upvote')
      expect(page).to_not have_link('downvote')
      expect(page).to_not have_link('undo vote')
    end
  end
end
