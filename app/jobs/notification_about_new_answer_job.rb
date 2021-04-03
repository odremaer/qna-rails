class NotificationAboutNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(question)
    SubscribersNotifierService.new.send_notify(question)
  end
end
