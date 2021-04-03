class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @new_questions = Question.recent_questions

    mail to: user.email
  end
end
