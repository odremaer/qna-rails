class NewAnswerMailer < ApplicationMailer
  def notify(subscription)
    @subscription = subscription

    mail to: subscription.user.email
  end
end
