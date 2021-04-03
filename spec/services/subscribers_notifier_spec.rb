require 'rails_helper'

RSpec.describe SubscribersNotifierService do
  let(:users) { create_list(:user, 3) }
  let(:question) { create(:question) }

  it 'sends notify about new answer for subscribed users' do
    users.length.times do |n|
       create(:subscription, user: users[n], question: question)
    end

    question.subscriptions.each { |subscription| expect(NewAnswerMailer).to receive(:notify).with(subscription).and_call_original }
    subject.send_notify(question)
  end
end
