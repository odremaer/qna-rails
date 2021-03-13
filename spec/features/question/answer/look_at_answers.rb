require 'rails_helper'

feature 'User can look at answers for question', %q{
  In order to find answer for your question
  As an user/guest
  I'd like to be able to look at existed answers for specific question
} do

  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 2) }

  scenario 'user looks at question' do
    question.answers.push(answers)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
      expect(page).to have_content answer.body
    end
  end
end
