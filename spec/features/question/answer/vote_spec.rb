require 'rails_helper'

feature 'User can vote for answers', %q{
  In order to rate a question
  As an user
  I'd like to be able to vote for answers
} do

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)

      visit question_path(question)
    end

    context 'not author' do
      scenario 'upvotes a answer' do
        within ".answers" do
          click_on 'upvote'
          expect(page).to have_content('1')
        end
      end

      scenario 'downvote a answer' do
        within '.answers' do
          click_on 'downvote'
          within('#vote-rating') { expect(page).to have_content('-1') }
        end
      end

      scenario 'undo his vote' do
        within '.answers' do
          click_on 'upvote'
          click_on 'undo vote'
          within('#vote-rating') { expect(page).to have_content('0') }
        end
      end
    end

    context 'author' do
      given(:answer) { create(:answer, user: user, question: question) }

      scenario 'votes' do
        within '.answers' do
          expect(page).to_not have_link('upvote')
          expect(page).to_not have_link('downvote')
          expect(page).to_not have_link('undo vote')
        end
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
