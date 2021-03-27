require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    context 'author' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'edits his answer' do
        within '.answers' do
          click_on 'Edit'
          field = find('textarea', id: "answer-edit-textarea")
          field.value.length.times { field.send_keys [:backspace] }
          field.send_keys('edited answer')

          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_selector 'textarea#answer-edit-textarea'
        end
      end

      scenario 'edits his answer with errors' do
        within '.answers' do
          click_on 'Edit'
          field = find('textarea', id: "answer-edit-textarea")
          field.value.length.times { field.send_keys [:backspace] }
          # field.native.clear
          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end

      scenario 'edits his answer with attached file' do
        within '.answers' do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'

          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    context 'not author' do
      scenario "tries to edit other user's answer" do
        not_author_user = create(:user)
        sign_in(not_author_user)

        visit question_path(question)

        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
