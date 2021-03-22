require 'rails_helper'

RSpec.describe Award, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user).optional }

  it { should validate_presence_of :title }

  it 'have one attached files' do
    expect(Award.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  describe '#give_award_to_user' do
    let(:user) { create(:user) }
    let(:award) { create(:award) }

    it 'should add award to user' do
      expect { award.give_award_to_user(user) }.to change(user.awards, :count).by(1)
    end
  end
end
