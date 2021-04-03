require 'rails_helper'

RSpec.describe NotificationAboutNewAnswerJob, type: :job do
  let(:service) { double('SubscribersNotifierService') }
  let(:question) { create(:question) }

  before do
    allow(SubscribersNotifierService).to receive(:new).and_return(service)
  end

  it 'calls SubscribersNotifierService#send_notify' do
    expect(service).to receive(:send_notify)
    NotificationAboutNewAnswerJob.perform_now(question)
  end
end
