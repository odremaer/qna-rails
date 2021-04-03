require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to get notifications about new answers
  As an authenticated user
  I'd like to be able to subscribe to question
} do

  given!(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'authenticated user' do
    context 'not author' do
      background do
        sign_in(user)

        visit question_path(question)
      end

      scenario 'can subscribe for question' do
        click_on 'Subscribe'

        expect(page).to have_link 'Unsubscribe'
        expect(page).to_not have_link 'Subscribe'
      end

      scenario 'can unsubscribe from question' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'

        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end

    context 'author' do
      background do
        sign_in(author)

        visit question_path(question)
      end

      scenario 'author can subscribe and unsubscribe' do
        click_on 'Unsubscribe'
        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_link 'Subscribe'

        click_on 'Subscribe'

        expect(page).to have_link 'Unsubscribe'
        expect(page).to_not have_link 'Subscribe'
      end
    end
  end

  describe 'unautheticated user' do
    it "can't subscribe for question" do
      visit question_path(question)

      expect(page).to_not have_link 'Unsubscribe'
      expect(page).to_not have_link 'Subscribe'
    end
  end
end
