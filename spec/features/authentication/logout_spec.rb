require 'rails_helper'

feature 'User can logout', %q{
  In order to close session
  As an authenticated user
  I'd like to be able to logout
} do

  given(:user) { create(:user) }

  background { visit questions_path }

  scenario 'Authenticated user tries to logout' do
    sign_in(user)

    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries to logout'do
    expect(page).to_not have_content 'Logout'
  end
end
