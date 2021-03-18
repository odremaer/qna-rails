require 'rails_helper'

feature 'Author can delete files that attached to question', %q{
  In order to delete attached file
  As an author
  I'd like to be able to delete attached file
} do

  given(:first_user) { create(:user) }
  given(:second_user) { create(:user) }

  given(:question) { create(:question, user: first_user) }

  scenario 'author deleting attached file', js: true do
    sign_in(first_user)

    visit question_path(question)

    within '.question' do
      click_on 'Edit'

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'

      click_on 'Delete image'

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario 'not author user tries to delete attached file', js: true do
    sign_in(second_user)

    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'not signed in user tries to delete attached file', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end
