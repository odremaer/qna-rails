require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }

    it { should_not be_able_to :create, Question }
    it { should_not be_able_to :create, Answer }
    it { should_not be_able_to :create, Comment }

    it { should_not be_able_to :update, Question }
    it { should_not be_able_to :update, Answer }

    it { should_not be_able_to :destroy, Question }
    it { should_not be_able_to :destroy, Answer }
  end

  describe 'for user' do
    let(:user) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:question_with_another_author) { create(:question) }

    let(:answer) { create(:answer, user: user, question: question) }
    let(:answer_with_another_author) { create(:answer) }

    let(:link) { create(:link, linkable: question) }
    let!(:link_with_another_linkable_author) { create(:link, linkable: question_with_another_author) }

    let(:vote) { create(:vote, votable: question_with_another_author, value: 1, user: user) }

    let(:subscription) { create(:subscription, user: user) }
    let(:subscription_with_not_subscribed_user) { create(:subscription)  }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :update, question }
    it { should be_able_to :update, answer }

    it { should be_able_to :destroy, question }
    it { should be_able_to :destroy, answer }

    it { should_not be_able_to :update, question_with_another_author }
    it { should_not be_able_to :update, answer_with_another_author }

    it { should_not be_able_to :destroy, question_with_another_author }
    it { should_not be_able_to :destroy, answer_with_another_author }

    it { should be_able_to :upvote, question_with_another_author }
    it { should be_able_to :downvote, question_with_another_author }
    it { should be_able_to :undo_vote, vote.votable }

    # because user is author of question
    it { should_not be_able_to :upvote, question }
    it { should_not be_able_to :downvote, question }
    it { should_not be_able_to :undo_vote, question }

    it { should be_able_to :choose_best, answer }
    it { should_not be_able_to :choose_best, answer_with_another_author }

    it 'should be able to destroy attachment' do
      question.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )
      file = question.files.first
      should be_able_to :destroy, file
    end

    it 'should not be able to destroy attachment' do
      question_with_another_author.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )
      file = question_with_another_author.files.first
      should_not be_able_to :destroy, file
    end

    it { should be_able_to :destroy, link }
    it { should_not be_able_to :destroy, link_with_another_linkable_author }

    it { should be_able_to :destroy, subscription }
    it { should_not be_able_to :destroy, subscription_with_not_subscribed_user }
  end
end
