class SubscribersNotifierService
  def send_notify(question)
    question.subscriptions.find_each(batch_size: 500) do |subscription|
      NewAnswerMailer.notify(subscription).deliver_later
    end
  end
end
