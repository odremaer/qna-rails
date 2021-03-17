require 'rails_helper'

feature 'User can pick the best answer', %q{
  In order to show the best answer first in the list
  As an author of question
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }


  scenario "Unauthenticated can't set best answer" do
    visit question_path(question)

    expect(page).to_not have_content 'Best answer'
  end

  describe 'Authenticated user', js: true do
    scenario 'author chooses the best answer' do
      sign_in(user)

      visit question_path(question)

      within '.answers' do
        page.check("best_answer")
        click_on 'Submit'

        expect(page).to have_checked_field("best_answer")
        expect(page).to have_content answer.body
      end
    end

    scenario "not author tries to choose the best answer" do
      not_author_user = create(:user)
      sign_in(not_author_user)

      visit question_path(question)

      expect(page).to_not have_content 'Best answer'
    end
  end
end
