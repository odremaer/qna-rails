require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question) }

  it 'should return true if user is author' do
    user.questions.push(question)

    expect(user).to be_author_of(question)
  end

  it 'should return false if user is not an author' do
    expect(user).to_not be_author_of(question)
  end

  describe '#all_except' do
    let(:users) { create_list(:user, 3) }
    let(:user) { users.first }
    it 'should return all existed users except the appointed one' do
      expect(User.all_except(user)).to_not include user
    end
  end
end
