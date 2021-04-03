# Preview all emails at http://localhost:3000/rails/mailers/new_answer_mailer
class NewAnswerMailerPreview < ActionMailer::Preview

 def notify
   NewAnswerMailer.notify(Question.last.subscriptions.first)
 end
end
