require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  it 'should return true if user is author' do
    user.questions.push(question)

    expect(user).to be_author_of(question)
  end

  it 'should return false if user is not an author' do
    expect(user).to_not be_author_of(question)
  end
end
