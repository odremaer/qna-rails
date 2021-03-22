require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:yt_url) { 'https://www.youtube.com/' }
  given(:gist_url) { 'https://gist.github.com/odremaer/1579b382ad42b1e48ba6cbef450689f8' }
  
  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My yt'
    fill_in 'Url', with: yt_url

    click_on 'Ask'

    expect(page).to have_link 'My yt', href: yt_url
  end

  scenario 'User adds gist link when asks a question', js: true do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_content 'Какое расширение у файлов Ruby?'
  end
end
