class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hello #{user.email}"
    @questions = Question.last_day_questions

    mail to: user.email, subject: 'Daily digest'
  end
end