require 'rails_helper'

feature 'User can look at questions list', %q{
  In order to look at existed questions
  As an user/guest
  I'd like to be able to look at questions list
} do
  scenario 'user looks at questions list' do
    visit questions_path

    expect(page).to have_content 'Questions'
  end
end
