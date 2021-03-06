require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:awards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

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

  describe '#admin?' do
    let(:admin) { create(:user, admin: true) }

    it 'should return true if user if admin' do
      expect(admin).to be_admin
    end

    it 'should return false if user is not admin' do
      expect(user).to_not be_admin
    end
  end

  describe '#subscribed?' do
    let(:subscription) { create(:subscription, question: question) }

    it 'should return true if user subscribed to question' do
      user.subscriptions.push(subscription)
      expect(user).to be_subscribed(question)
    end

    it 'should return false if user not subscribed to question' do
      expect(user).to_not be_subscribed(question)
    end
  end
end
