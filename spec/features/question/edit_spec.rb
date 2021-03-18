require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user', js: true do
    context 'author' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'edits his question' do
        within '.question' do
          click_on 'Edit'

          fill_in 'Title of your question', with: 'edited title question'
          fill_in 'Your question', with: 'edited body question'

          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited title question'
          expect(page).to have_content 'edited body question'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his question with errors' do
        within '.question' do
          click_on 'Edit'
          title_field = find('textarea#question_title')
          body_field = find('textarea#question_body')

          title_field.value.length.times { title_field.send_keys [:backspace] }
          body_field.value.length.times { body_field.send_keys [:backspace] }

          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end

      scenario 'edits his question with attached file' do
        within '.question' do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    context 'not author' do
      scenario "tries to edit other user's question" do
        not_author_user = create(:user)
        sign_in(not_author_user)

        visit question_path(question)
        within '.question' do
          expect(page).to_not have_link 'Edit'
        end
      end
    end
  end
end
